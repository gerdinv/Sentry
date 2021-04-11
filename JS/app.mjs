import { CourierClient } from "@trycourier/courier";
import express from "express";
import dotenv from "dotenv";
dotenv.config();
const app = express();

const courier = CourierClient({
  authorizationToken: dotenv.COURIER_AUTH_TOKEN,
}); // get from the Courier UI

app.use(express.json());

app.listen(3000, () => {
  console.log("server is running");
});

app.get("/sendText", async (req, res) => {
  console.log(req.body);
  const { message } = await courier.send({
    eventId: req.body.eventId, // get from the Courier UI
    recipientId: req.body.recipientId, // usually your system's User ID
    profile: {
      phone_number: req.body.profile.phone_number,
      email: req.body.profile.email,
    },
    data: {
      receiverName: req.body.data.receiverName,
      senderName: req.body.data.senderName,
    },
  });
  res.send(message);
});
