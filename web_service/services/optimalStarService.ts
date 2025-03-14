import {IStar} from "../models/documents/star";

export class OptimalStarService {
	static findOptimalStar(observerRightAscension: number, observerDeclination: number, stars: IStar[]) {
		// stars closest to the zenith/nadir at the end of the list (higher index, higher score)
		stars.sort((a, b) => this.distanceFromObserverPoint(observerRightAscension, observerDeclination, a) <= this.distanceFromObserverPoint(observerRightAscension, observerDeclination, b) ? 1 : -1);

		const properNameScore = stars.length + 20; // always want proper name to take precedent
		const observableToNakedEyeScore = stars.length + 6;
		const hasBfDesignationScore = stars.length + 4;
		const multipleStarsScore = stars.length + 3;

		let optimalStar = stars[0]; // assume first star was best
		let maxScore = -1;
		for (const star of stars) {
			let score = stars.indexOf(star);
			if (star.properName) {
				score += properNameScore;
			}
			if (star.numStars > 1) {
				score += multipleStarsScore;
			}
			if (star.magnitude < 5.5) {
				score += observableToNakedEyeScore;
			}
			if (star.bfDesignation) {
				score += hasBfDesignationScore;
			}

			if (score > maxScore) {
				optimalStar = star;
				maxScore = score;
			}
		}

		return optimalStar;
	}

	private static distanceFromObserverPoint(rightAscension: number, declination: number, star: IStar) {
		return Math.sqrt(
			Math.pow(star.rightAscension - rightAscension, 2) + Math.pow(star.declination - declination, 2));
	}
}
