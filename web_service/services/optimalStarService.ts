import {IStar} from "../models/documents/star";

export default class OptimalStarService {
	findOptimalStar(stars: IStar[]) {
		// always prioritize if the star is named
		const optimalStar = null;
		for (const star of stars) {
			console.log(this.distanceFromPoint(0, 0, star));
		}
	}

	distanceFromPoint(rightAscension: number, declination: number, star: IStar) {
		return Math.sqrt(
			Math.pow(this.hoursToDegrees(star.rightAscension) - this.hoursToDegrees(rightAscension), 2)
			+ Math.pow(star.declination - declination, 2));
	}

	hoursToDegrees(hours: number) {
		return hours * 15.0;
	}
}
