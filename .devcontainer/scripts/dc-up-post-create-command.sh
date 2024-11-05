#!/usr/bin/env bash

set -x
set -e

# shellcheck disable=SC1091 source=.devcontainer/scripts/data.tmp
source /workspaces/nix-workspace/.devcontainer/scripts/data.tmp

# process name:value args
declare NEWUSER
for arg in "${@}"; do
	if [[ $arg =~ ^user: ]]; then
		NEWUSER="${arg#*:}"
	fi
done

declare -a ebuilds=(
	app-admin/sudo
	app-misc/tmux
	app-portage/eix
)

# these commands also run as root

time emerge --quiet --sync
printf "\n"

time emerge --jobs=2 -tvN @world
printf "\n"

time emerge --jobs=2 -tv app-portage/gentoolkit
printf "\n"

time emerge --noreplace --jobs=2 -tv "${ebuilds[@]}"
printf "\n"

time eix-update
printf "\n"

if [[ -n ${NEWUSER} ]]; then
	printf "Allowing password-less sudo for user %s\n" "${NEWUSER}"
	mkdir -pv /etc/sudoers.d/
	tee >/etc/sudoers.d/020_user-nopasswd <<-EOF
		${NEWUSER} ALL=(ALL) NOPASSWD: ALL
	EOF
fi

# shellcheck disable=SC2154
{
	if ! getent group | grep -q -E "^${devcontainer_username}:"; then
		groupadd --gid "${devcontainer_gid}" "${devcontainer_username}"
	fi
	if ! getent passwd | grep -q -E "^${devcontainer_username}:"; then
		useradd --uid "${devcontainer_uid}" --gid "${devcontainer_gid}" --no-create-home --groups wheel,kvm,portage "${devcontainer_username}"
	fi
	chsh --shell /bin/sh "${devcontainer_username}"
	printf "%s\n%s\n" "${devcontainer_password}" "${devcontainer_password}" | passwd "${devcontainer_username}"
	id "${devcontainer_username}"
}

tee >/usr/local/bin/dc-user-setup-ssh-agent <<-EOF
	#!/usr/bin/env sh

	# this script assumes that you will run it once and then start tmux which
	# will inherit the environment on all future shells.

	if [[ -z \${SSH_AUTH_SOCK} ]]; then
		ssh-agent | tee ~/.ssh-agent-settings-dc.txt
		chmod -v 0600 ~/.ssh-agent-settings-dc.txt
		printf "\n"

		source ~/.ssh-agent-settings-dc.txt
		printf "\n"

		sleep 1s

		ssh-add -L
		printf "\n"

		printf "Please use\n\n\tssh-add ~/.ssh/id_keyname\n\nto add keys to your ssh-agent.\n"
	else
		source ~/.ssh-agent-settings-dc.txt
		printf "\n"

		sleep 1s

		ssh-add -L
		printf "\n"
	fi
EOF
chmod -v 0755 /usr/local/bin/dc-user-setup-ssh-agent
