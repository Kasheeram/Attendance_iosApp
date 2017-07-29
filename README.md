# Attendance iOs App for Employees

## Login Screen
<img src="https://user-images.githubusercontent.com/19978447/28743013-b734ef38-745c-11e7-96dc-a702db7041e4.png" width="100" height="50">


From this screen user can register and login to this app, for the user authentication i used firbase authentication

## Registration Screen 

![register](https://user-images.githubusercontent.com/19978447/28743034-6ffb2938-745d-11e7-9803-eb9f617a21be.png)

From this screen user can register and all the user details will be stored in firebase database and user credentials will store in firebase authentication with generating a unique user id  

## Calendar for Attendance

![calendar](https://user-images.githubusercontent.com/19978447/28743074-60df3560-745e-11e7-838f-e19ebd572a19.png)

This is the calendar and currented date is selected byy default and date color is red that means user din't mark the attendance
Note: Before going to calendar i am checking the user current location's latitude, longitude for checking that user is peresented in office or not, if user location is outside the define region then user attendance will not be accepted.

## After user tapped on the current date

![intime](https://user-images.githubusercontent.com/19978447/28743105-4029a4ee-745f-11e7-90fb-a660120b8c18.png)


When user will tapped on the current date then date color will change red to yellow that means user done entry time attendance 

## After user tapped second time on current date

![outingtime](https://user-images.githubusercontent.com/19978447/28743123-a7acb3cc-745f-11e7-8911-a20eaa2efff9.png)

When user will tapped second time on the current date and second time if user is tapping after 8:30 hrs then current date color will change yellow to green that meaans user completed him/her working hrs.

## Status Screen

![simulator screen shot jul 28 2017 5 47 20 pm](https://user-images.githubusercontent.com/19978447/28743150-75a34548-7460-11e7-9c4e-3d30a45af9d6.png)

User can also check their self status by tapping on status button, in the status screen user can check last 30 day attendance status like date , intime, out time and total duration[no of hours] 


