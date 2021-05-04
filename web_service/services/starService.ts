import StarRepository from "../repositories/starRepository";

export default class StarService {
  async makeStarSandiwch(model: MakeStarSandwichModel): Promise<Array<any>> {
    const repo = new StarRepository();
    const RA = this.getRightAscension(model.longitude);
    return repo.findStars([RA, model.latitude]);
  }

  getRightAscension(longitude: number): number {
    const LST = this.getLocalSiderealTimeInDegrees();
    const RA = (longitude + LST) / 15; // hrs
    return RA;
  }

  getLocalSiderealTimeInDegrees(): number {
    const now = new Date();
    const julianDays = this.getJulianDays(now);

    const T = (julianDays - 2451545.0) / 36525; // Julian centuries
    const greenwichSiderealAngle =
      280.46061837 +
      360.98564736629 * (julianDays - 2451545.0) +
      0.000387933 * Math.pow(T, 2) -
      Math.pow(T, 3) / 38710000.0;

    return greenwichSiderealAngle % 360;
  }

  getJulianDays(timestamp: Date) {
    return timestamp.getTime() / 86400000 + 2440587.5;
  }
}
