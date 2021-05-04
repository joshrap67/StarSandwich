export default class StarService {

    async makeStarSandiwch(coordinates) {
        const latitude = coordinates['latitude'];
        const longitude = coordinates['longitude'];
    }


     getLocalSiderealTime(longitude) {
        const now = new Date();
        const julianDays = now.getJulian();

        const T = ((julianDays - 2451545)) / 26525; // Julian centuries
        const greenwichSiderealAngle = 280.46061837 + 360.98564736629 * (julianDays - 2451545.0) + (0.000387933 * Math.pow(T, 2)) - (Math.pow(T, 3) / 38710000.0);

        console.log(greenwichSiderealAngle);
    }

    
}

Date.prototype.getJulian = function() {
    return Math.floor((this / 86400000) - (this.getTimezoneOffset() / 1440) + 2440587.5);
}