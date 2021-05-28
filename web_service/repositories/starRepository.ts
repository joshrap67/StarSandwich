import Star from "../models/documents/star";

export class StarRepository {
	static async findStars(coords: number[]) {
		const resultList = [];
		try {
			const results = await Star.find({
				rightAscension: {
					$gte: coords[0] - 0.1,
					$lte: coords[0] + 0.1
				},
				declination: {$gte: coords[1] - 1.0, $lte: coords[1] + 1.0}
			});
			results.map((result) => resultList.push(result.toObject()));
		} catch (e) {
			console.log(e);
		}
		return resultList;
	}
}
