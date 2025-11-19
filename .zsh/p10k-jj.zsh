# Custom jj-vcs segment for p10k
# In order to make it I took inspiration from these posts:
# - https://zerowidth.com/2025/async-zsh-jujutsu-prompt-with-p10k/
# - https://andre.arko.net/2025/06/20/a-jj-prompt-for-powerlevel10k/

typeset -g _jj_vcs_display=""
typeset -g _jj_vcs_workspace=""

prompt_jj_vcs() {
  local workspace

  # Here we verify that jj is installed and that we are in a jj workspace
  command -v jj >/dev/null 2>&1 || return
  if workspace=$(jj workspace root 2>/dev/null); then
    p10k display "*/jj-vcs=show"
    p10k display "*/vcs=hide"
  else
    p10k display "*/jj-vcs=hide"
    p10k display "*/vcs=show"
    return
  fi

  # Here we track the workspace to prevent stale cache, as we are using async jobs
  if [[ $_jj_vcs_workspace != "$workspace" ]]; then
    _jj_vcs_display=""
    _jj_vcs_workspace="$workspace"
  fi

  # Here we start the async job
  async_job _jj_vcs_worker _jj_vcs_async "$workspace"

  # Here we render the segment
  p10k segment -t '$_jj_vcs_display' -e
}

# Async job function
# Its function is to extract the necessary information from the jj workspace and build the segment display string
_jj_vcs_async() {
  local workspace=$1
  local max_depth=${JJ_PROMPT_MAX_DEPTH:-80} # override to search deeper ancestry if needed

  local jj_template
  jj_template=$(cat <<'JJT'
concat(
  self.change_id().shortest(4), "|",
  self.bookmarks().map(|b| b.name()).join(","), "|",
  self.empty(), "|",
  (self.description().len() > 0), "|",
  self.conflict(), "|",
  if(self.current_working_copy(), self.diff().files().filter(|f| f.status()=="added").len(), 0), "|",
  if(self.current_working_copy(), self.diff().files().filter(|f| f.status()=="modified").len(), 0), "|",
  if(self.current_working_copy(), self.diff().files().filter(|f| f.status()=="removed").len(), 0), "|",
  if(self.current_working_copy(), self.diff().files().filter(|f| (f.status()=="renamed") || (f.status()=="copied")).len(), 0),
  "\n"
)
JJT
)

  # One jj call: walk first-parent history until we find a bookmark anchor.
  local raw_data
  if ! raw_data=$(jj log --repository "$workspace" --ignore-working-copy \
      --no-graph --color never \
      -r "first_ancestors(@, ${max_depth})" \
      -T "$jj_template" 2>/dev/null); then
    return 1
  fi

  [[ -z "$raw_data" ]] && return 1

  local -a lines
  lines=("${(@f)raw_data}")
  [[ ${#lines[@]} -eq 0 ]] && return 1

  local -a wc_fields=()
  local anchor=""
  local distance=""
  local idx=0

  for line in "${lines[@]}"; do
    [[ -z "$line" ]] && continue

    local -a fields=()
    local IFS="|"
    read -rA fields <<< "$line"

    if (( idx == 0 )); then
      wc_fields=("${fields[@]}")
    fi

    if [[ -z "$anchor" && -n "${fields[2]}" ]]; then
      anchor="${fields[2]%%,*}"
      distance=$idx
    fi

    ((idx++))
  done

  (( ${#wc_fields[@]} == 0 )) && return 1

  local change_id="${wc_fields[1]}"
  local is_empty="${wc_fields[3]}"
  local has_desc="${wc_fields[4]}"
  local is_conflict="${wc_fields[5]}"
  local -i added=${wc_fields[6]:-0}
  local -i modified=${wc_fields[7]:-0}
  local -i deleted=${wc_fields[8]:-0}
  local -i renamed=${wc_fields[9]:-0}

  if [[ -z "$anchor" ]]; then
    anchor="$change_id"
    distance=""
  fi

  # --- Determine display state ---
  local color=""
  local state_icon=""

  local c_red="%F{1}"
  local c_green="%F{2}"
  local c_yellow="%F{3}"
  local c_teal="%F{6}"
  local c_reset="%f"

  if [[ "$is_conflict" == "true" ]]; then
    color="$c_red"
    state_icon="!"
  elif [[ "$is_empty" == "false" ]]; then
    color="$c_yellow"
  elif [[ "$has_desc" == "true" ]]; then
    color="$c_teal"
  else
    color="$c_green"
  fi

  local display="${color}${anchor}"

  if [[ -n "$distance" && "$distance" -gt 0 ]]; then
    display+=" ›${distance}"
  fi

  if [[ -n "$state_icon" ]]; then
    display+=" ${state_icon}"
  fi

  if [[ "$is_empty" == "false" ]]; then
    local stats_parts=()
    (( added > 0 )) && stats_parts+=("+${added}")
    (( modified > 0 )) && stats_parts+=("~${modified}")
    (( renamed > 0 )) && stats_parts+=("↻${renamed}")
    (( deleted > 0 )) && stats_parts+=("-${deleted}")

    if (( ${#stats_parts[@]} )); then
      display+=" ${stats_parts[*]}"
    fi
  fi

  display+="${c_reset}"
  echo "$display"
}

# Async callback function
# This function is called when the async job is done
# It updates the display variable and triggers a prompt redraw
_jj_vcs_callback() {
  local job_name=$1 exit_code=$2 output=$3 execution_time=$4 stderr=$5 next_pending=$6
  if [[ $exit_code == 0 ]]; then
    _jj_vcs_display=$output
  else
    # Fallback on error
    _jj_vcs_display="%F{red}err%f"
  fi
  p10k display -r
}

async_init
async_stop_worker _jj_vcs_worker 2>/dev/null
async_start_worker _jj_vcs_worker
async_unregister_callback _jj_vcs_worker 2>/dev/null
async_register_callback _jj_vcs_worker _jj_vcs_callback
