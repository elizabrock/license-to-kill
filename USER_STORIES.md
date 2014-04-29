# User Stories

## Viewing the Menu

As someone that's unfamiliar with the application
I want to see a list of options
So that I can continue on

Acceptance Criteria:
  * If the user selects 1, they see "Who do you want to add?"
  * If the user selects 2, they see "What is the injury you want to add?"
  * If the user selects 3, they see "Who is injured?"
  * If the user types in anything else, they should see "<input> is an invalid selection" and the menu should be printed out again

Usage:

    > ./living_will_to_die
    What do you want to do?
    1. Add Person
    2. Add Injury
    3. Evaluate Injured Person

## Add Injury

As someone hoping to murder their friends (err... a nice friend)
I want to enter an exhaustive list of potential injuries
So that I know when my friend wants to shuffle off this mortal coil

Acceptance Criteria:

  * Unique injuries will be added to the database
  * Duplicate injuries can't be added

Usage:

    > ./living_will_to_die
    What do you want to do?
    1. Add Person
    2. Add Injury
    3. Evaluate Injured Person
    - 2
    What is the injury you want to add?
    - Decapitation
    Decapitation has been added.
