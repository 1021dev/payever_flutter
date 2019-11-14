# Checkout App

- The checkout app mimics the logic that the web checkout have.
    + first it ask for the structure and create a flow object.
    + with it the stepper come into place and create each step.
    + each step is redenring the correspond widget.

    - thats the theory and the way it was thought
      but the current implementation works stopping the stepper at the
      order section. The reason for it was that at the begining the checkout was
      meant to follow an ecommerce flow but in reality it wount work.
      Therefore the logic needs to be restructured.
    
- The section that are in use are the order_namual and order_tester.

