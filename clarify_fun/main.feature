Feature: We should have a LB for our control plane and its components and as
  such we should configure the proper security groups and listeners

  Scenario: we are using a single LB to route to all control plane components
    Given Terraform
    And a "aws_instance" of type "resource"
    Then attribute "instance_type" equals "m1.small"
    And it occurs exactly 1 times

  Scenario Outline: Every component of the control plane which needs a LB
    should be properly configured to have one

    Given Terraform
    And a "aws_security_group" of type "resource"
    And "our component is <component>"
    When attribute "ingress" exists
    Then attribute "ingress" matches regex "from_port.*<port>"
    And attribute "ingress" matches regex "to_port.*<port>"

    Examples:
    | port | component |
    | 22   | aws_security_group       |
    | 80   | aws_security_group       |