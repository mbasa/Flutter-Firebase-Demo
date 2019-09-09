# flutter_firebase_demo

Sample Application that uses Firebase Cloud Messaging and the Real Time
DataStore.


## Getting Started

A few resources on Firebase and Flutter setup: 

- [Firebase Setup](https://firebase.google.com/docs/flutter/setup)
- [firebase_messaging](https://pub.dev/packages/firebase_messaging)
- [Flutter Setup][http://myhexaville.com/2018/04/09/flutter-push-notifications-with-firebase-cloud-messaging/]

## Android

For Android, the following files have to be modified.

- android/build.gradle
- android/app/build.gradle
- android/app/src/main/AndroidManifest.xml


## Sending messages

Server example using Curl to send messages to a particular device:

* The device token ID can be obtained by
  `_firebaseMessaging.getToken().then((String token) {
  debugPrint("Token: $token"); });`
```
DATA='{"notification": {"body": "This is sample message sent by Curl 2","title": "Test Message"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to":"eviQ01QXHGA:APA91bGktpjKHM3xdE759Ae1iw1ADPKysqFR1CjTm_t_nOCk6-aZjoSO52VRn-ZeFOaIIft7Ne-6PzFdldOoLIYt6Sz93QEXTmr0Gy8G1LKK10K3F-X-9uVnBsVajouRwJSmqphBGN88"}'
```

* The device can also be subscribed to a Subscription. This way
  broadcast messages can be sent to all members of the registered
  Subscription. The application is subscibed to `all` topic.
  
```  
DATA='{"notification": {"body": "This is a test Message. Please ignore. Message is sent via Curl.","title": "Message from Server"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to":"/topics/all"}'
```  

* The Authorization Key can be obtained from the *Firebase Console*
```
curl https://fcm.googleapis.com/fcm/send 
 -H "Content-Type:application/json" 
 -X POST -d "$DATA" 
 -H "Authorization: key=[AUTHORIZATION_KEY]"
```