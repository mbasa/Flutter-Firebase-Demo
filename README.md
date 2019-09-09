# flutter_firebase_demo

Sample Application that uses Firebase Cloud Messaging

## Getting Started

A few resources on Firebase and Flutter setup: 

- [Firebase Setup](https://firebase.google.com/docs/flutter/setup)
- [firebase_messaging](https://pub.dev/packages/firebase_messaging)
- [Flutter Setup][http://myhexaville.com/2018/04/09/flutter-push-notifications-with-firebase-cloud-messaging/]

## Sending messages

Server example using Curl to send messages to a particular device:

* The device token ID can be gotten by 
`_firebaseMessaging.getToken().then((String token) {
      debugPrint("Token: $token");
    });`
```
DATA='{"notification": {"body": "This is sample message sent by Curl 2","title": "Test Message"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to":"eviQ01QXHGA:APA91bGktpjKHM3xdE759Ae1iw1ADPKysqFR1CjTm_t_nOCk6-aZjoSO52VRn-ZeFOaIIft7Ne-6PzFdldOoLIYt6Sz93QEXTmr0Gy8G1LKK10K3F-X-9uVnBsVajouRwJSmqphBGN88"}'
```

* The Authorization Key can be gotten from the *Firebase Console*
```
curl https://fcm.googleapis.com/fcm/send 
 -H "Content-Type:application/json" 
 -X POST -d "$DATA" 
 -H "Authorization: key=AAAAO3KZ20g:APA91bHIhL3o5EHWnzQBlDP-yKJyBz9vy7EWKJw8YyNM7XaQWk_lgJFbDYXq5-nGYAvZY1FVUpJ_VbSJkA0OCzRQnU5UdMP7ZKfZS6ycxH44MA72wgyQY_17HvmUvKL9TgoUb7XrVmQ8"
```