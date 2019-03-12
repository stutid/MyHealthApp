# MyHealthApp
A health app which lets you see your genetics result and measure heart rate

I have created a login UI, logout UI, genetics result UI and heart rate measurement for the app users.

I have used MVVM design pattern.

I am using UserData.json and GeneticsData.json, which contain the JSON response in the same manner as we will receive from the APIs.

I have mocked the behavior of the following RESTful APIs:

Customer:

• POST - /customer/login

• POST - /customer/logout

• GET - /customer/{customerId}/user

Genetics:

• GET - /customer/{customerId}/genetic

Lifestyle:

• POST - /customer/{customerId}/heartrate




Steps to use the application:

• Run the application and it will lead you to the login screen.

• I have put a validation check on empty textfields. It will prompt you to enter email address/password.

• You can enter any email address and password, and it will let you enter the application.

• On the click of login, /customer/login, gets fired.

• The next screen is the customer details UI, containing firstname, lastname, email, dob, genetics result, which are all loaded from the local JSON files saved in the project in the same format as the response from the APIs. (UserData.json and GeneticsData.json)

• I have fired both, /customer/{customerId}/user and /customer/{customerId}/genetic, on the same screen through getUserData() and getGeneticsData() but as of now they load the data from two local JSON files mentioned above.

• On the same UI, at the bottom of the screen is the “Check your Heartrate” button. Click on the button and it will prompt you to put your finger on the camera and measure the heart rate. After it is finished measuring heartrate, an alert gets displayed on the screen with the user’s current heartrate measurements and at the same moment, /customer/{customerId}/heartrate, gets fired with the heartrate and timestamp as parameters to the API.

• I have used a HeartRateKit library to measure the heart rate. This library provides us with delegate methods, which gives us the HeartRateKitResult. This result parameter has the information of beats per minute, which I have used to display to the user.

• At the top right corner of the customer details screen, there is a logout button. Logout API, /customer/logout gets triggered when logout button is pressed and user is returned back to the login screen.
