# Products app 

- Products app have a different implementation because its using graphql. so the use of the DB wil be different.
    - Taking into cosideration that on the moment of the development the gql support was really poor.
    - the implemtation works on the following way:
        + the implementation is achived with widgets and not by controllers. The repo implementation works as a future builder.
          and is used as the main loader for the first data fetch.
        + the Scaffold widget have a bottom navigation bar with the minimun height posible so it not visible,
          inside will be hidden a loader widget.(so its separated from the view it self but also having impact on it).
          this hidden implementation is for the scroll controller to have a way to keep loading data without losing the data already load.
        + the same implementation works on the pos product page.
    - even though that it was a work arround the complications at the moment its completly stable.


