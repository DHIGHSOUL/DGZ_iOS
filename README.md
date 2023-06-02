## **KETI_Donggongzizin_iOS application**
The iOS application is designed with the goal of reducing confusion during and after an earthquake. By providing a UI (User Interface) and UX (User Experience) that matches the scenarios before, during, and after an earthquake, we aim to provide users with relevant action guidelines, ensuring faster and more accurate information provision.

The following details the View, Layout, and information the application provides according to different situations.

### **Normal State (Stable Situation)**

First, consider the state of stability when an earthquake has not occurred. In this state, we primarily provide information on what measures users should take in preparation for an earthquake.

- How to prepare before an earthquake occurs
- A page summarizing information about earthquakes and guidelines that can help prepare for when an earthquake happens
- Continuous monitoring for any occurrence of an earthquake, and promptly changing the View and Layout to reflect the situation during an earthquake when one occurs
![BASIC 001](https://github.com/DHIGHSOUL/DGZ_iOS/assets/73047755/ee9cae50-d102-4e92-b306-ba6aef7d5db4)

### **While Earthquake (During an Earthquake)**

When an earthquake occurs, we recognize that there's a limit to the information that can be provided within the application. We, therefore, link to the Meteorological Agency's webpage, which we deem to provide the most accurate guidelines for action during an earthquake, and encourage users to open the page. This helps users access the necessary actions during an earthquake more quickly.

- When an earthquake, measure the current latitude and longitude and upload them to the Mobius platform
- Provide the magnitude and maximum expected intensity of the current earthquake
- Link to the Meteorological Agency's 'Action Guidelines during an Earthquake' page to provide information on how users should act during an earthquake
- Continuously monitor whether the earthquake has ended, and immediately change the View and Layout to the post-earthquake state when it has
![BASIC 002](https://github.com/DHIGHSOUL/DGZ_iOS/assets/73047755/151384ae-606c-448c-99fe-72fc63d7b02b)

### **After Earthquake (After an Earthquake)**

After an earthquake, we provide information about post-earthquake response and evacuation guidelines and provide the shortest route to the nearest shelter to assist users in evacuating quickly.

- Provide information about the final measured magnitude and the maximum measured intensity of the occurred earthquake
- Provide brief information about the action guidelines after an earthquake
- Use the latitude and longitude uploaded to the Mobius platform to generate a KakaoMap API URL, and display the shortest route to the nearest shelter through the KakaoMap application.
![BASIC 003](https://github.com/DHIGHSOUL/DGZ_iOS/assets/73047755/e2cc8a31-2c81-4285-a38c-26373eac4d47)
