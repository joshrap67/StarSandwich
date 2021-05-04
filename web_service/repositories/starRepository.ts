import mongoose from "mongoose";
import { Star } from "../models/star";

const DB_URL = "";
const mong = mongoose
  .connect(DB_URL)
  .then((result) => console.log("connected"))
  .catch((error) => console.log(console.error()));

export default class StarRepository {
  async findStars(coords: Array<number>) {
    var resultList = [];
    try {
      var results = await Star.find({
        rightAscension: {
          $gte: coords[0] - 0.25,
          $lte: coords[0] + 0.25,
        },
        declination: { $gte: coords[1] - 2.5, $lte: coords[1] + 2.5 },
      });
      results.map((result) => resultList.push(result));
    } catch (e) {
      console.log(e);
    }
    return resultList;
  }
}
