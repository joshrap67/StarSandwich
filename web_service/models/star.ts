import mongoose from "mongoose";
const Schema = mongoose.Schema;

interface Star {
  _id: string;
  hipId: string;
  hdId: string;
  hrId: string;
  glId: string;
  bfDesignation: string;
  properName: string;
  rightAscension: number;
  declination: number;
  distance: number;
  magnitude: number;
  absMagnitude: number;
  constellation: string;
  numStars: number;
  luminosity: number;
}

const starScheme = new Schema({
  hipId: String,
  hdId: String,
  hrId: String,
  glId: String,
  bfDesignation: String,
  properName: String,
  rightAscension: Number,
  declination: Number,
  distance: Number,
  magnitude: Number,
  absMagnitude: Number,
  constellation: String,
  numStars: Number,
  luminosity: Number,
});

export const Star = mongoose.model("star", starScheme);
