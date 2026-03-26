# Non-login shells don't read ~/.bash_profile; load env without circular sourcing.
if [ -z "${PROFILE_LOADED:-}" ]; then
  [ -f "$HOME/.bash_profile" ] && . "$HOME/.bash_profile"
fi
