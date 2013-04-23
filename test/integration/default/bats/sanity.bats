# This is a basic sanity test, to ensure that the plugins work as designed.

@test "gives me a /tmp directory" {
  [ -d /tmp ]
}
