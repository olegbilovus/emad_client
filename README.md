# emad_client - CAApp

Flutter application for Enterprise Mobile Application Development project.
<br>
<img src="https://github.com/user-attachments/assets/2a67ff79-855f-4582-aeaa-2079a34f5b55" width=200, height=200>

CAApp is a multiplatform application for **Augmentative Alternative Communication**. Through the prompt, it is possible to insert a sentence and obtain a sequence of images **(PECS)** to communicate with people with complex communication needs. It also offers the possibility of generating custom images generated with **GenAI** and image storage via Firebase.

## Technical informations
CAApp is structured on a Client-Server architecture, based on [RestAPI](https://it.wikipedia.org/wiki/Representational_state_transfer)
- Backend available [here](https://github.com/olegbilovus/emad_restapi)
- PECS generation algorithm available [here](https://github.com/olegbilovus/emad_images)
- GenAI supplied by [Azure](https://azure.microsoft.com)

## Dependencies required
|                         | Android |  iOS  | Linux | macOS |  Web  | Windows |
|-------------------------|:-------:|:-----:|:-----:|:-----:|:-----:|:-------:|
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)       |   ✅    |   ✅   |   ✅   |   ✅   |   ✅   |   ✅    |
| [connectivity_plus](https://pub.dev/packages/connectivity_plus)   |   ✅    |   ✅   |   ✅   |   ✅   |   ✅   |   ✅    |
| [get](https://pub.dev/packages/get)                               |   ✅    |   ✅   |   ✅   |   ✅   |   ✅   |   ✅    |
| [lottie](https://pub.dev/packages/lottie)                         |   ✅    |   ✅   |       |   ✅   |       |   ✅    |
| [animated_text_kit](https://pub.dev/packages/animated_text_kit)   |   ✅    |   ✅   |   ✅   |   ✅   |   ✅   |   ✅    |
| [simple_gradient_text](https://pub.dev/packages/simple_gradient_text) |   ✅    |   ✅   |   ✅   |   ✅   |   ✅   |   ✅    |
| [shared_preferences](https://pub.dev/packages/shared_preferences) |   ✅    |   ✅   |   ✅   |   ✅   |   ✅   |   ✅    |
| [speech_to_text](https://pub.dev/packages/speech_to_text)         |   ✅    |   ✅   |       |   ✅   |   ✅   |         |
|[firebase_core](https://pub.dev/packages/firebase_core)            |   ✅    |   ✅   |       |   ✅   |   ✅   |    ✅    |
|[firebase_auth](https://pub.dev/packages/firebase_auth)            |   ✅    |   ✅   |       |   ✅   |   ✅   |    ✅    |
|[firebase_ui_auth](https://pub.dev/packages/firebase_ui_auth)      |   ✅    |   ✅   |       |       |       |         |
|[cloud_firestore](https://pub.dev/packages/cloud_firestore)        |   ✅    |   ✅   |       |   ✅   |   ✅   |    ✅    |
|[image_picker](https://pub.dev/packages/image_picker)              |   ✅    |   ✅   |   ✅   |   ✅   |   ✅   |   ✅    |
|[http](https://pub.dev/packages/http)                              |   ✅    |   ✅   |   ✅   |   ✅   |   ✅   |   ✅    |

## Demo
https://github.com/user-attachments/assets/5c6622dd-b55c-49b3-bde5-7a1ab18bbca8



