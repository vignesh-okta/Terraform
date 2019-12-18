resource "okta_group" "test_other" {
  name = "testAcc_new_uuid"
}

resource "okta_group_rule" "test" {
  name              = "testAcc_replace_with_uuid"
  status            = "ACTIVE"
  group_assignments = ["${okta_group.test_other.id}"]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "String.startsWith(user.articulateId,String.toLowerCase(\"auth0|\"))"
}
