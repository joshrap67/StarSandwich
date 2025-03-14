import mongoose from "mongoose";

export interface IStar extends mongoose.Document<string> {
	hipId: string,
	hdId: string,
	hrId: string,
	glId: string,
	bfDesignation: string,
	properName: string,
	rightAscension: number,
	declination: number,
	distance: number,
	magnitude: number,
	absMagnitude: number,
	constellation: string,
	numStars: number,
	luminosity: number,
}

export const starScheme = new mongoose.Schema({
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
	luminosity: Number
});

const Star = mongoose.model<IStar>("star", starScheme);

export default Star;
