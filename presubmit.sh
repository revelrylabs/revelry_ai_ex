echo "Running pre-push checks (skip with --no-verify)..."

interrupt() {
  echo "\n"
  echo "Trapped the INT signal, exiting..."
  # https://tldp.org/LDP/abs/html/exitcodes.html
  exit 130
}

print_skip_message() {
  echo "\n"
  echo "Checks failed, see above. You can skip them by running git push --no-verify."
}

trap interrupt INT
# Ensure the skip message is printed when the script exits
trap '[[ $? -ne 0 ]] && print_skip_message' EXIT

mix format --check-formatted
if [ $? -ne 0 ]; then
  exit 1
fi

mix dialyzer
if [ $? -ne 0 ]; then
  exit 1
fi

mix test
if [ $? -ne 0 ]; then
  exit 1
fi
