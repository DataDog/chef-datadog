@test "pymongo is installed and imports ok" {
  run python -c "import pymongo"
  [ "$status" -eq 0 ]
}
