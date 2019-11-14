# payever

- The following app is structured to be able to run on modules, always keeping the common module as center of the app.
    - Each module contain a variation of the mvc design pattern.
    - Each module (in theory) should be self contained.
    - The use of provider to take care of the state management.
        - Each provider have the name of the app its managing + "StateModel"(ProductStateModel).
        - Provider could be located inside the common folder or an individual module depending on the use of it. if its used in more than one service or not.

# Where to improve?

- Theme:
    - the current App has no theme nor style applied to it. A theme would keep away the manual input of values all over the app and help keeping the styling guidelines. 
    - try to replicate the "ngkit" that web uses with local widgets so the app could have one uniform look inside each module.

- Restructure the checkout:
    - The current implementation for the checkout was planned for an Ecommerce checkout and it was until the end that the implementation changed.
        + the current implementation has hardcoded the function to just open the order section and ignore the web structure.
    
- Error handling:
    - currently the app in some cases handle errors with snackbars(checkout) and other with popups(transacion) or both (product).

- Integration with a Flutter CI/CD:
    - https://www.bitrise.io/
    - https://codemagic.io/start/
    