curl_file() {
  local url=https://raw.githubusercontent.com/pbrisbin/arch-setup/main/files/$1
  curl --location --silent --fail "$url"
}
