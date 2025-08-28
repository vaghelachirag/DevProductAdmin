const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const fetch = require("node-fetch");

const app = express();

// Allow requests from your Flutter Web app
app.use(cors({ origin: "https://devproductadmin.web.app" }));

app.use(express.json()); // to parse JSON body

app.post("/addData", async (req, res) => {
  try {
    // Forward request to Google Apps Script
    const url = "https://script.google.com/macros/s/YOUR_SCRIPT_ID/exec";

    const response = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(req.body),
    });

    const result = await response.json();
    res.json(result);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Export Firebase Function
exports.api = functions.https.onRequest(app);
