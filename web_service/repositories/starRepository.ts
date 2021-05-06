import mongoose from "mongoose";
import {DB_URL} from "../config";
import Star from "../models/documents/star";

const mongooseConnection = mongoose
	.connect(DB_URL)
	.then(() => console.log("MongoDB connection active"))
	.catch(() => console.log(console.error()));

export default class StarRepository {
	async findStars(coords: number[]) {
		const resultList = [];
		try {
			const results = await Star.find({
				rightAscension: {
					$gte: coords[0] - 0.25,
					$lte: coords[0] + 0.25
				},
				declination: {$gte: coords[1] - 2.5, $lte: coords[1] + 2.5}
			});
			results.map((result) => resultList.push(result.toObject()));
		} catch (e) {
			console.log(e);
		}
		return resultList;
	}
}
