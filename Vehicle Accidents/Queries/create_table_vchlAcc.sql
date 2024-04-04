DROP TABLE IF EXISTS accident;

CREATE TABLE accident (
	"AccidentIndex" VARCHAR(255),
	"Severity" TEXT,
	"Date" DATE,
	"Day" TEXT,
	"SpeedLimit" INT,
	"LightConditions" TEXT,
	"WeatherConditions" TEXT,
	"RoadConditions" TEXT,
	"Area" TEXT
);


DROP TABLE IF EXISTS vehicle;

CREATE TABLE vehicle (
	  "VehicleID" VARCHAR(255),
	  "AccidentIndex" VARCHAR(255),
	  "VehicleType" TEXT,
	  "PointImpact" TEXT,
	  "LeftHand" TEXT,
	  "JourneyPurpose" TEXT,
	  "Propulsion" TEXT,
	  "AgeVehicle" INT
);