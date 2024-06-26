_openeuler_config_file="/etc/yum.repos.d/openEuler.repo"

check() {
	source_os_release
	[ "$NAME" = "openEuler" ]
}

install() {
	config_file=$_openeuler_config_file
	set_sudo

	$sudo cp ${config_file} ${config_file}.bak || {
		print_error "Failed to backup ${config_file}"
		return 1
	}

	new_file=$(sed -E "s|https?://([^/]+)|${http}://${domain}/openeuler|" $config_file)
	{
		cat << EOF | $sudo tee ${config_file} > /dev/null
# ${gen_tag}
${new_file}
EOF
	} || {
		print_error "Failed to add mirror to ${config_file}"
		return 1
	}
}

is_deployed() {
	config_file=$_openeuler_config_file
	$sudo grep -q "${gen_tag}" ${config_file}
}

can_recover() {
	bak_file=${_openeuler_config_file}.bak
	test -f $bak_file
}

uninstall() {
	config_file=$_openeuler_config_file
	set_sudo
	$sudo mv ${config_file}.bak ${config_file} || {
		print_error "Failed to recover ${config_file}"
		return 1
	}
}

# vim: set filetype=sh ts=4 sw=4 noexpandtab:
