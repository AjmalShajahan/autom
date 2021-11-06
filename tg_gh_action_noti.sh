#!/bin/bash

# Get the token from Travis environment vars and build the bot URL:
BOT_URL="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"

# Set formatting for the message. Can be either "Markdown" or "HTML"
PARSE_MODE="Markdown"

status=$INPUT_STATUS
# Define send message function. parse_mode can be changed to
# HTML, depending on how you want to format your message:

send_msg() {
    curl -s -X POST ${BOT_URL} -d chat_id=$CHAT_ID \
        -d text="$1" -d parse_mode=${PARSE_MODE}
}


# Send message to the bot with some pertinent details about the job
# Note that for Markdown, you need to escape any backtick (inline-code)
# characters, since they're reserved in bash

if [[ "$GITHUB_EVENT_NAME" == "issues" ]] ; then
send_msg "

[Issue ${PR_STATE}](https://github.com/${GITHUB_REPOSITORY}/issues/${IU_NUM})
Issue Title and Number  : ${IU_TITLE} | #${IU_NUM}

Commented or Created By : \`${IU_ACTOR}\`

Issue Body : *${IU_BODY}*

[Build log]("https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}/checks")
"
elif  [[ "$GITHUB_EVENT_NAME" == "issue_comment" ]] ; then
send_msg "

[Issue ${PR_STATE}](https://github.com/${GITHUB_REPOSITORY}/issues/${IU_NUM})
Issue Title and Number  : ${IU_TITLE} | #${IU_NUM}

Commented or Created By : \`${IU_ACTOR}\`

Issue Body : *${IU_BODY}*

Issue Comment: \`${IU_COM}\`


[Build log]("https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}/checks")
"
elif [[ "$GITHUB_EVENT_NAME" == "pull_request" ]] ; then
send_msg "

[PR ${PR_STATE}]("https://github.com/${GITHUB_REPOSITORY}/pull/${PR_NUM}")

PR Title and Number  :      ${PR_NUM}
Created By:          ${GITHUB_ACTOR}


PR Body:        *${PR_BODY}*



[Build log]("https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}/checks")
"
elif  [[ "$GITHUB_EVENT_NAME" == "watch" ]] ; then
send_msg "

ID: ${GITHUB_WORKFLOW}

Action was a *${status}!*

By:            *${GITHUB_ACTOR}*

\`Repository:  ${GITHUB_REPOSITORY}\`

Star Count      ${STARGAZERS}

Fork Count      ${FORKERS}

[Link]("https://github.com/${GITHUB_REPOSITORY}/")

"
elif [[ "$GITHUB_EVENT_NAME" == "schedule" ]] ; then
send_msg "

ID: ${GITHUB_WORKFLOW}

Action was a *${status}!*

*Action was Run on Schedule*

\`Repository:  ${GITHUB_REPOSITORY}\`


[Link to Repo ]("https://github.com/${GITHUB_REPOSITORY}/")

"

else
send_msg "

ID: ${GITHUB_WORKFLOW}

Action was a *${status}!*

\`Repository:  ${GITHUB_REPOSITORY}\`

On:          *${GITHUB_EVENT_NAME}*

By:            *${GITHUB_ACTOR}*

Tag:        ${GITHUB_REF}

[Link]("https://github.com/${GITHUB_REPOSITORY}/")
"
fi
