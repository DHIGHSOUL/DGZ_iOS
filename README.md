## **KETI_Donggongzizin_iOS application**
The iOS application is designed with the goal of reducing confusion during and after an earthquake. By providing a UI (User Interface) and UX (User Experience) that matches the scenarios before, during, and after an earthquake, we aim to provide users with relevant action guidelines, ensuring faster and more accurate information provision.

The following details the View, Layout, and information the application provides according to different situations.

### **Normal State (Stable Situation)**

First, consider the state of stability when an earthquake has not occurred. In this state, we primarily provide information on what measures users should take in preparation for an earthquake.

- How to prepare before an earthquake occurs
- A page summarizing information about earthquakes and guidelines that can help prepare for when an earthquake happens
- Continuous monitoring for any occurrence of an earthquake, and promptly changing the View and Layout to reflect the situation during an earthquake when one occurs
![32977D71-6AF8-42C5-B59A-43719F1AAB71_1_101_o](https://github.com/DHIGHSOUL/DGZ_iOS/assets/73047755/102d5c11-a566-4137-bd2c-c770381cf4a8)
![2CB3836D-A065-4652-957E-3BBA2B5F5289_1_101_o](https://github.com/DHIGHSOUL/DGZ_iOS/assets/73047755/5da0c646-f4e1-421d-915b-6272800757b5)

### **While Earthquake (During an Earthquake)**

When an earthquake occurs, we recognize that there's a limit to the information that can be provided within the application. We, therefore, link to the Meteorological Agency's webpage, which we deem to provide the most accurate guidelines for action during an earthquake, and encourage users to open the page. This helps users access the necessary actions during an earthquake more quickly.

- When an earthquake, measure the current latitude and longitude and upload them to the Mobius platform
- Provide the magnitude and maximum expected intensity of the current earthquake
- Link to the Meteorological Agency's 'Action Guidelines during an Earthquake' page to provide information on how users should act during an earthquake
- Continuously monitor whether the earthquake has ended, and immediately change the View and Layout to the post-earthquake state when it has
![7D00160E-62DD-4687-8223-C491FC9DF56B_1_101_o](https://github.com/DHIGHSOUL/DGZ_iOS/assets/73047755/eb4e5a3b-f8e7-44c7-9a7a-05989b6bde53)
![4075BFF9-7466-44EC-81D0-467AD3262EA5_1_101_o](https://github.com/DHIGHSOUL/DGZ_iOS/assets/73047755/5bec2ab8-66f9-4fa2-bbf8-34c470c4504e)

### **After Earthquake (After an Earthquake)**
![DE1C4B20-DC83-4E3C-8CA6-4726BBF40E5B_1_101_o](https://github.com/DHIGHSOUL/DGZ_iOS/assets/73047755/3d3e5227-58f9-4cda-b99f-dbdf885557c1)

After an earthquake, we provide information about post-earthquake response and evacuation guidelines and provide the shortest route to the nearest shelter to assist users in evacuating quickly.

- Provide information about the final measured magnitude and the maximum measured intensity of the occurred earthquake
- Provide brief information about the action guidelines after an earthquake
- Use the latitude and longitude uploaded to the Mobius platform to generate a KakaoMap API URL, and display the shortest route to the nearest shelter through the KakaoMap application.
