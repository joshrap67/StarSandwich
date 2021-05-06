import {IStar} from "../models/documents/star";

export default class OptimalStarService {
	findOptimalStar(observerRightAscension: number, observerDeclination: number, stars: IStar[]) {
		// stars closest to the zenith/nadir at the bottom of the list (higher index, higher point)
		stars.sort((a, b) => this.distanceFromObserverPoint(observerRightAscension, observerDeclination, a) <= this.distanceFromObserverPoint(observerRightAscension, observerDeclination, b) ? 1 : -1);

		const properNameScore = stars.length + 10; // always want proper name to take precedent
		const multipleStarsScore = stars.length + 4;
		const observableToNakedEyeScore = stars.length + 8;
		const hasBfDesignationScore = stars.length + 5;

		const starScores = new Map<IStar, number>();
		for (const star of stars) {
			starScores.set(star, stars.indexOf(star)) // sort values give stars their initial scores
			if (star.properName !== undefined && star.properName) {
				starScores.set(star, starScores.get(star) + properNameScore);
			}
			if (star.numStars !== undefined && star.numStars > 1) {
				starScores.set(star, starScores.get(star) + multipleStarsScore);
			}
			if (star.magnitude !== undefined && star.magnitude < 5.5) {
				starScores.set(star, starScores.get(star) + observableToNakedEyeScore);
			}
			if (star.bfDesignation !== undefined && star.bfDesignation) {
				starScores.set(star, starScores.get(star) + hasBfDesignationScore);
			}
		}

		let optimalStar = stars[0]; // assume first star was best
		for (const star of stars) {
			const score = starScores.get(star);
			if (score > starScores.get(optimalStar)) {
				optimalStar = star;
			}
		}
		return optimalStar;
	}

	distanceFromObserverPoint(rightAscension: number, declination: number, star: IStar) {
		return Math.sqrt(
			Math.pow(star.rightAscension - rightAscension, 2)
			+ Math.pow(star.declination - declination, 2));
	}
}
