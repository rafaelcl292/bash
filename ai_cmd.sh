#!/bin/bash

AI_PROMPT=$(
    cat <<'EOF'
You are a helpful assistant for a user running WSL Ubuntu Linux.
Context:
- OS: Ubuntu 22.04.5 LTS (WSL)
- Main editor: nvim
- Tools installed: fd, ripgrep (rg)
Task: Given the user's shell command or an error message they show, output a single improved shell command that accomplishes the user's intent or fixes the error.
Rules:
- Output ONLY the plain command. No explanations, no markdown, no quotes, no code fences.
- Keep the same general intent; improve correctness, efficiency, and best practices for WSL Ubuntu.
- If the user's input shows an error, return the corrected command that addresses it.

When searching for files or directories, use the `fd` command with appropriate flags:
Main fd options:
  -H, --hidden            Search hidden files and directories
  -I, --no-ignore         Do not respect .(git|fd)ignore files
  -s, --case-sensitive    Case-sensitive search (default: smart case)
  -i, --ignore-case       Case-insensitive search (default: smart case)
  -g, --glob              Glob-based search (default: regular expression)
  -a, --absolute-path     Show absolute instead of relative paths
  -l, --list-details      Use a long listing format with file metadata
  -L, --follow            Follow symbolic links
  -p, --full-path         Search full abs. path (default: filename only)
  -d, --max-depth <depth> Set maximum search depth
  -t, --type <filetype>   Filter by type: file (f), directory (d), symlink (l), executable (x), empty (e)
  -e, --extension <ext>   Filter by file extension
  -E, --exclude <pattern> Exclude entries that match the given glob pattern

When searching file contents, use the `rg` command with main flags:
Main rg options:
  -i, --ignore-case       Case insensitive search
  -s, --case-sensitive    Case sensitive search
  -g, --glob=GLOB         Include or exclude file paths
  -t, --type=TYPE         Only search files matching TYPE
  -L, --follow            Follow symbolic links
  -H, --with-filename     Print the file path with each matching line
  -n, --line-number       Show line numbers
  -v, --invert-match      Invert matching
  -A, --after-context=NUM Show NUM lines after each match
  -B, --before-context=NUM Show NUM lines before each match
  -c, --count             Show count of matching lines for each file
  -l, --files-with-matches Print the paths with at least one match
EOF
)

openai_regenerate_cmd() {
    current_cmd=$(echo "$READLINE_LINE")
    if [ -z "$current_cmd" ]; then
        return
    fi

    if [ -z "$CEREBRAS_API_KEY" ]; then
        return
    fi

    full_prompt="$AI_PROMPT

Original input:
$current_cmd"

    system_content=$(printf '%s' "$full_prompt" | jq -Rs .)
    user_content=$(printf '%s' "$current_cmd" | jq -Rs .)

    response=$(curl -s --location 'https://api.cerebras.ai/v1/chat/completions' \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${CEREBRAS_API_KEY}" \
        --data "{
            \"model\": \"gpt-oss-120b\",
            \"stream\": false,
            \"max_tokens\": 65536,
            \"temperature\": 1,
            \"top_p\": 1,
            \"reasoning_effort\": \"medium\",
            \"messages\": [
                {\"role\": \"system\", \"content\": $system_content},
                {\"role\": \"user\", \"content\": $user_content}
            ]
        }")

    if [ $? -eq 0 ]; then
        new_cmd=$(echo "$response" | jq -r '.choices[0].message.content' 2>/dev/null | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if [ -n "$new_cmd" ] && [ "$new_cmd" != "null" ]; then
            READLINE_LINE="$new_cmd"
            READLINE_POINT=${#READLINE_LINE}
        fi
    fi
}
