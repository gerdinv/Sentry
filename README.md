# Sentry
BIT CAMP 2021
<br />
<p align="center">
  <a href="https://github.com/gerdinv/Sentry">
    <img src="https://cdn.discordapp.com/attachments/429515082075209739/830763886579679232/sentryLogo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Sentry</h3>

  <p align="center">
    The Sentry app is an ios app which provides the user with a sense of security as well as a safe and efficient way to contact emergency services.
    Sentry - Stationed to keep watch
    <br />
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project
Sentry is an app that uses the Courier API to send texts to a designated list of emergency contacts created by the user. Sentry uses Swift’s long tap gesture as a way to indicate when the user is in danger. Once the user releases the sentry button a timer is activated. The timer serves as an indicator of when emergency services will be notified.


### Inspiration
We noticed a lack of applications that utilized a phone’s capabilities in geolocation and communication software in a manner that protects the phone user in dangerous situations. We aimed to make an app that utilizes this software to give people a sense of security.


###What we learned:
* Technologies such as Geotechnologies and Courier
* How to connect a JS backend to a Swift application
* Collaborating on tasks help us get more work done

###Challenges:
* Connecting to the backend to the Swift application.
* Geodecoding map values to produce a valid readable street address



### Built With

This app was built primarily with Swift storyboard and we used Parse for the backend. We also created a separate JS server that made special requests using the Courier API to send text messages
* [Bootstrap](https://developer.apple.com/swift/)
* [JQuery](https://www.javascript.com/)



<!-- GETTING STARTED -->
## Getting Started

To get started, make sure you have the latest version of NodeJS installed. 

### Installation

1. Create an account at Twilio and link it to Courier. [https://docs.courier.com/docs/getting-started-twilio](https://docs.courier.com/docs/getting-started-twilio) 
2. Navigate to the JS directory and run ```npm install```
4. Create a .env file and paste your Courier Auth Token and Courier notification id.
   ```
    COURIER_AUTH_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    COURIER_NOTIFICATION_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxxx 
    ```
3. Start the NodeJS server.
4. Navigate to the SwiftFiles directory and run ```pod install```
5. Open the HomeViewController file and replace the ip in the link with your IPV4 address
6. Run the program and enjoy using the app!


<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.


<!-- CONTACT -->
## Contact

Gerdin Ventura - [@linkedin](https://www.linkedin.com/in/gerdin-ventura-croussett-2b28081a3/) - gerdinventuraedu@gmail.com
<br />
Armando Taveras - [@linkedin](https://www.linkedin.com/in/armando-taveras-04731216a/) - armandogtaveras@gmail.com
<br />
Tony Che - [@linkedin](https://www.linkedin.com/in/tony-ch%C3%A9-b59624202/) - t_che@outlook.com

Project Link: [https://github.com/gerdinv/Sentry](https://github.com/gerdinv/Sentry)
