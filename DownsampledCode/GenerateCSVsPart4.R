# Load necessary libraries
library(tidyverse)
library(readxl)
library(lubridate)
library(ggplot2)
library(maps)
library(ggmap)

# Set working directory
setwd("/Volumes/Extreme SSD/ORNLDriverIDsCSVFormat")

G1_Subject15 <- "G1_Subject15.csv"
G1_Subject16 <- "G1_Subject16.csv"
G2_Subject13 <- "G2_Subject13.csv"
G3_Subject13 <- "G3_Subject13.csv"

dataframes <- list(G1_Subject15, G1_Subject16, G2_Subject13, G3_Subject13)

# Loop through each dataframe
for (file_name in dataframes) {

# For subjects with no VBOX data
# For sheets 15, 16, 30, 46
  data <- read.csv(file_name)

# Separate CANbus data by directly selecting the columns
canbus_data <- data %>%
  select("Time91", "X91.Accelerator.Pedal.Position.1", "Time2945", "X2945.Active.Shift.Console.Indicator", 
         "Time513", "X513.Actual.Engine...Percent.Torque", "Time4154", "X4154.Actual.Engine...Percent.Torque..Fractional.", 
         "Time3357", "X3357.Actual.Maximum.Available.Engine...Percent.Torque", "Time1717", "X1717.Actual.Maximum.Available.Retarder...Percent.Torque", 
         "Time3031", "X3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1", "Time1761", "X1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume", 
         "Time4765", "X4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature", "Time3251", "X3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure", 
         "Time3242", "X3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature", "Time3610", "X3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure", 
         "Time3246", "X3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature", "Time5466", "X5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold", 
         "Time3721", "X3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration", "Time3241", "X3241.Aftertreatment.1.Exhaust.Temperature.1", 
         "Time3229", "X3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature", "Time3232", "X3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI", 
         "Time3226", "X3226.Aftertreatment.1.Outlet.NOx.1", "Time3230", "X3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable", 
         "Time3231", "X3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable", "Time4360", "X4360.Aftertreatment.1.SCR.Intake.Temperature", 
         "Time5862", "X5862.Aftertreatment.1.SCR.Intermediate.Temperature", "Time4363", "X4363.Aftertreatment.1.SCR.Outlet.Temperature", 
         "Time3239", "X3239.Aftertreatment.2.Intake.Dew.Point", "Time171", "X171.Ambient.Air.Temperature", 
         "Time108", "X108.Barometric.Pressure", "Time168", "X168.Battery.Potential...Power.Input.1", 
         "Time117", "X117.Brake.Primary.Pressure", "Time118", "X118.Brake.Secondary.Pressure", 
         "Time5313", "X5313.Commanded.Engine.Fuel.Rail.Pressure", "Time7319", "X7319.Cruise.Control.Speed", 
         "Time512", "X512.Driver.s.Demand.Engine...Percent.Torque", "Time515", "X515.Engine.s.Desired.Operating.Speed", 
         "Time185", "X185.Engine.Average.Fuel.Economy", "Time110", "X110.Engine.Coolant.Temperature", 
         "Time101", "X101.Engine.Crankcase.Pressure.1", "Time2432", "X2432.Engine.Demand...Percent.Torque", 
         "Time1136", "X1136.Engine.ECU.Temperature", "Time3216", "X3216.Engine.Exhaust.1.NOx.1", 
         "Time1209", "X1209.Engine.Exhaust.Bank.1.Pressure.1", "Time2659", "X2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate", 
         "Time412", "X412.Engine.Exhaust.Gas.Recirculation.1.Temperature", "Time27", "X27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position", 
         "Time975", "X975.Engine.Fan.1.Estimated.Percent.Speed", "Time986", "X986.Engine.Fan.1.Requested.Percent.Speed", 
         "Time157", "X157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure", "Time183", "X183.Engine.Fuel.Rate", 
         "Time184", "X184.Engine.Instantaneous.Fuel.Economy", "Time132", "X132.Engine.Intake.Air.Mass.Flow.Rate", 
         "Time102", "X102.Engine.Intake.Manifold..1.Pressure", "Time105", "X105.Engine.Intake.Manifold.1.Temperature", 
         "Time100", "X100.Engine.Oil.Pressure.1", "Time92", "X92.Engine.Percent.Load.At.Current.Speed", 
         "Time898", "X898.Engine.Requested.Speed.Speed.Limit", "Time4191", "X4191.Engine.Requested.Torque..Fractional.", 
         "Time518", "X518.Engine.Requested.Torque.Torque.Limit", "Time190", "X190.Engine.Speed", "Time190.CAN0", "X190.Engine.Speed.CAN0",
         "Time51", "X51.Engine.Throttle.Valve.1.Position.1", "Time250", "X250.Engine.Total.Fuel.Used", 
         "Time247", "X247.Engine.Total.Hours.of.Operation", "Time236", "X236.Engine.Total.Idle.Fuel.Used", 
         "Time235", "X235.Engine.Total.Idle.Hours", "Time249", "X249.Engine.Total.Revolutions", 
         "Time182", "X182.Engine.Trip.Fuel", "Time1172", "X1172.Engine.Turbocharger.1.Compressor.Intake.Temperature", 
         "Time103", "X103.Engine.Turbocharger.1.Speed", "Time641", "X641.Engine.Variable.Geometry.Turbocharger.Actuator..1", 
         "Time2978", "X2978.Estimated.Engine.Parasitic.Losses...Percent.Torque", "Time5398", "X5398.Estimated.Pumping...Percent.Torque", 
         "Time904", "X904.Front.Axle.Speed", "Time96", "X96.Fuel.Level.1", 
         "Time1242", "X1242.Instantaneous.Estimated.Brake.Power", "Time4207", "X4207.Message.Checksum", 
         "Time4206", "X4206.Message.Counter", "Time5015", "X5015.Momentary.Engine.Maximum.Power.Enable", 
         "Time514", "X514.Nominal.Friction...Percent.Torque", "Time187", "X187.Power.Takeoff.Set.Speed", 
         "Time905", "X905.Relative.Speed..Front.Axle..Left.Wheel", "Time906", "X906.Relative.Speed..Front.Axle..Right.Wheel", 
         "Time907", "X907.Relative.Speed..Rear.Axle..1..Left.Wheel", "Time908", "X908.Relative.Speed..Rear.Axle..1..Right.Wheel", 
         "Time1087", "X1087.Service.Brake.Circuit.1.Air.Pressure", "Time1088", "X1088.Service.Brake.Circuit.2.Air.Pressure", 
         "Time3544", "X3544.Time.Remaining.in.Engine.Operating.State", "Time245", "X245.Total.Vehicle.Distance", 
         "Time161", "X161.Transmission.1.Input.Shaft.Speed", "Time191", "X191.Transmission.1.Output.Shaft.Speed", 
         "Time526", "X526.Transmission.Actual.Gear.Ratio", "Time5052", "X5052.Transmission.Clutch.Converter.Input.Speed", 
         "Time523", "X523.Transmission.Current.Gear", "Time177", "X177.Transmission.Oil.Temperature.1", 
         "Time524", "X524.Transmission.Selected.Gear", "Time574", "X574.Transmission.Shift.In.Process", 
         "Time573", "X573.Transmission.Torque.Converter.Lockup.Engaged", "Time4816", "X4816.Transmission.Torque.Converter.Lockup.Transition.in.Process", 
         "Time3030", "X3030.Transmission.Torque.Converter.Ratio", "Time1029", "X1029.Trip.Average.Fuel.Rate", 
         "Time244", "X244.Trip.Distance", "Time918", "X918.Trip.Distance..High.Resolution.", 
         "Time2979", "X2979.Vehicle.Acceleration.Rate.Limit.Status", "Time84", "X84.Wheel.Based.Vehicle.Speed", 
         "timestampsLocation", "longitude", "latitude", "timestampHeading", 
         "gpsSpeed", "headingDegree", "timestampSat", "numSats", "EDATime", "EDA",
         "HRTime", "HRTime", "HR", "IBITime", "IBI")

# Convert epoch time to POSIXct
canbus_data <- canbus_data %>%
  mutate(across(starts_with("Time"), ~ as.POSIXct(., origin = "1970-01-01", tz = "UTC")),
         timestampHeading = as.POSIXct(timestampHeading, origin = "1970-01-01", tz = "UTC"),
         timestampsLocation = as.POSIXct(timestampsLocation, origin = "1970-01-01", tz = "UTC"),
         timestampSat = as.POSIXct(timestampsLocation, origin = "1970-01-01", tz = "UTC"),
         EDATime = as.POSIXct(EDATime, origin = "1970-01-01", tz = "UTC"),
         HRTime = as.POSIXct(HRTime, origin = "1970-01-01", tz = "UTC"),
         IBITime = as.POSIXct(IBITime, origin = "1970-01-01", tz = "UTC"))

# Round timestamps to the nearest second
canbus_data <- canbus_data %>%
  mutate(across(starts_with("Time"), ~ round_date(., unit = "second")),
         timestampHeading = round_date(timestampHeading, unit = "second"),
         timestampsLocation = round_date(timestampsLocation, unit = "second"),
         timestampSat = round_date(timestampSat, unit = "second"),
         EDATime = round_date(EDATime, unit = "second"),
         HRTime = round_date(HRTime, unit = "second"),
         IBITime = round_date(IBITime, unit = "second"))

# Downsample and rename each variable to a common time column
downsampled_91 <- canbus_data %>%
  group_by(Time = Time91) %>%
  summarize(mean.91.Accelerator.Pedal.Position.1 = mean(`X91.Accelerator.Pedal.Position.1`, na.rm = TRUE),
            sd.91.Accelerator.Pedal.Position.1 = sd(`X91.Accelerator.Pedal.Position.1`, na.rm = TRUE),
            max.91.Accelerator.Pedal.Position.1 = ifelse(all(is.na(`X91.Accelerator.Pedal.Position.1`)), NA, max(`X91.Accelerator.Pedal.Position.1`, na.rm = TRUE)),
            min.91.Accelerator.Pedal.Position.1 = ifelse(all(is.na(`X91.Accelerator.Pedal.Position.1`)), NA, min(`X91.Accelerator.Pedal.Position.1`, na.rm = TRUE)))


downsampled_2945 <- canbus_data %>%
  group_by(Time = Time2945) %>%
  summarize(mean.2945.Active.Shift.Console.Indicator = mean(`X2945.Active.Shift.Console.Indicator`, na.rm = TRUE),
            sd.2945.Active.Shift.Console.Indicator = sd(`X2945.Active.Shift.Console.Indicator`, na.rm = TRUE),
            max.2945.Active.Shift.Console.Indicator = ifelse(all(is.na(`X2945.Active.Shift.Console.Indicator`)), NA, max(`X2945.Active.Shift.Console.Indicator`, na.rm = TRUE)),
            min.2945.Active.Shift.Console.Indicator = ifelse(all(is.na(`X2945.Active.Shift.Console.Indicator`)), NA, min(`X2945.Active.Shift.Console.Indicator`, na.rm = TRUE)))


downsampled_513 <- canbus_data %>%
  group_by(Time = Time513) %>%
  summarize(mean.513.Actual.Engine...Percent.Torque = mean(`X513.Actual.Engine...Percent.Torque`, na.rm = TRUE),
            sd.513.Actual.Engine...Percent.Torque = sd(`X513.Actual.Engine...Percent.Torque`, na.rm = TRUE),
            max.513.Actual.Engine...Percent.Torque = ifelse(all(is.na(`X513.Actual.Engine...Percent.Torque`)), NA, max(`X513.Actual.Engine...Percent.Torque`, na.rm = TRUE)),
            min.513.Actual.Engine...Percent.Torque = ifelse(all(is.na(`X513.Actual.Engine...Percent.Torque`)), NA, min(`X513.Actual.Engine...Percent.Torque`, na.rm = TRUE)))


downsampled_4154 <- canbus_data %>%
  group_by(Time = Time4154) %>%
  summarize(mean.4154.Actual.Engine...Percent.Torque..Fractional. = mean(`X4154.Actual.Engine...Percent.Torque..Fractional.`, na.rm = TRUE),
            sd.4154.Actual.Engine...Percent.Torque..Fractional. = sd(`X4154.Actual.Engine...Percent.Torque..Fractional.`, na.rm = TRUE),
            max.4154.Actual.Engine...Percent.Torque..Fractional. = ifelse(all(is.na(`X4154.Actual.Engine...Percent.Torque..Fractional.`)), NA, max(`X4154.Actual.Engine...Percent.Torque..Fractional.`, na.rm = TRUE)),
            min.4154.Actual.Engine...Percent.Torque..Fractional. = ifelse(all(is.na(`X4154.Actual.Engine...Percent.Torque..Fractional.`)), NA, min(`X4154.Actual.Engine...Percent.Torque..Fractional.`, na.rm = TRUE)))


downsampled_3357 <- canbus_data %>%
  group_by(Time = Time3357) %>%
  summarize(mean.3357.Actual.Maximum.Available.Engine...Percent.Torque = mean(`X3357.Actual.Maximum.Available.Engine...Percent.Torque`, na.rm = TRUE),
            sd.3357.Actual.Maximum.Available.Engine...Percent.Torque = sd(`X3357.Actual.Maximum.Available.Engine...Percent.Torque`, na.rm = TRUE),
            max.3357.Actual.Maximum.Available.Engine...Percent.Torque = ifelse(all(is.na(`X3357.Actual.Maximum.Available.Engine...Percent.Torque`)), NA, max(`X3357.Actual.Maximum.Available.Engine...Percent.Torque`, na.rm = TRUE)),
            min.3357.Actual.Maximum.Available.Engine...Percent.Torque = ifelse(all(is.na(`X3357.Actual.Maximum.Available.Engine...Percent.Torque`)), NA, min(`X3357.Actual.Maximum.Available.Engine...Percent.Torque`, na.rm = TRUE)))


downsampled_1717 <- canbus_data %>%
  group_by(Time = Time1717) %>%
  summarize(mean.1717.Actual.Maximum.Available.Retarder...Percent.Torque = mean(`X1717.Actual.Maximum.Available.Retarder...Percent.Torque`, na.rm = TRUE),
            sd.1717.Actual.Maximum.Available.Retarder...Percent.Torque = sd(`X1717.Actual.Maximum.Available.Retarder...Percent.Torque`, na.rm = TRUE),
            max.1717.Actual.Maximum.Available.Retarder...Percent.Torque = ifelse(all(is.na(`X1717.Actual.Maximum.Available.Retarder...Percent.Torque`)), NA, max(`X1717.Actual.Maximum.Available.Retarder...Percent.Torque`, na.rm = TRUE)),
            min.1717.Actual.Maximum.Available.Retarder...Percent.Torque = ifelse(all(is.na(`X1717.Actual.Maximum.Available.Retarder...Percent.Torque`)), NA, min(`X1717.Actual.Maximum.Available.Retarder...Percent.Torque`, na.rm = TRUE)))


downsampled_3031 <- canbus_data %>%
  group_by(Time = Time3031) %>%
  summarize(mean.3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1 = mean(`X3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1`, na.rm = TRUE),
            sd.3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1 = sd(`X3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1`, na.rm = TRUE),
            max.3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1 = ifelse(all(is.na(`X3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1`)), NA, max(`X3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1`, na.rm = TRUE)),
            min.3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1 = ifelse(all(is.na(`X3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1`)), NA, min(`X3031.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Temperature.1`, na.rm = TRUE)))


downsampled_1761 <- canbus_data %>%
  group_by(Time = Time1761) %>%
  summarize(mean.1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume = mean(`X1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume`, na.rm = TRUE),
            sd.1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume = sd(`X1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume`, na.rm = TRUE),
            max.1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume = ifelse(all(is.na(`X1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume`)), NA, max(`X1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume`, na.rm = TRUE)),
            min.1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume = ifelse(all(is.na(`X1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume`)), NA, min(`X1761.Aftertreatment.1.Diesel.Exhaust.Fluid.Tank.Volume`, na.rm = TRUE)))


downsampled_4765 <- canbus_data %>%
  group_by(Time = Time4765) %>%
  summarize(mean.4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature = mean(`X4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature`, na.rm = TRUE),
            sd.4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature = sd(`X4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature`, na.rm = TRUE),
            max.4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature = ifelse(all(is.na(`X4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature`)), NA, max(`X4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature`, na.rm = TRUE)),
            min.4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature = ifelse(all(is.na(`X4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature`)), NA, min(`X4765.Aftertreatment.1.Diesel.Oxidation.Catalyst.Intake.Temperature`, na.rm = TRUE)))


downsampled_3251 <- canbus_data %>%
  group_by(Time = Time3251) %>%
  summarize(mean.3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure = mean(`X3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure`, na.rm = TRUE),
            sd.3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure = sd(`X3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure`, na.rm = TRUE),
            max.3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure = ifelse(all(is.na(`X3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure`)), NA, max(`X3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure`, na.rm = TRUE)),
            min.3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure = ifelse(all(is.na(`X3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure`)), NA, min(`X3251.Aftertreatment.1.Diesel.Particulate.Filter.Differential.Pressure`, na.rm = TRUE)))


downsampled_3242 <- canbus_data %>%
  group_by(Time = Time3242) %>%
  summarize(mean.3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature = mean(`X3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature`, na.rm = TRUE),
            sd.3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature = sd(`X3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature`, na.rm = TRUE),
            max.3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature = ifelse(all(is.na(`X3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature`)), NA, max(`X3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature`, na.rm = TRUE)),
            min.3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature = ifelse(all(is.na(`X3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature`)), NA, min(`X3242.Aftertreatment.1.Diesel.Particulate.Filter.Intake.Temperature`, na.rm = TRUE)))


downsampled_3610 <- canbus_data %>%
  group_by(Time = Time3610) %>%
  summarize(mean.3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure = mean(`X3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure`, na.rm = TRUE),
            sd.3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure = sd(`X3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure`, na.rm = TRUE),
            max.3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure = ifelse(all(is.na(`X3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure`)), NA, max(`X3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure`, na.rm = TRUE)),
            min.3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure = ifelse(all(is.na(`X3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure`)), NA, min(`X3610.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Pressure`, na.rm = TRUE)))


downsampled_3246 <- canbus_data %>%
  group_by(Time = Time3246) %>%
  summarize(mean.3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature = mean(`X3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature`, na.rm = TRUE),
            sd.3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature = sd(`X3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature`, na.rm = TRUE),
            max.3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature = ifelse(all(is.na(`X3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature`)), NA, max(`X3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature`, na.rm = TRUE)),
            min.3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature = ifelse(all(is.na(`X3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature`)), NA, min(`X3246.Aftertreatment.1.Diesel.Particulate.Filter.Outlet.Temperature`, na.rm = TRUE)))


downsampled_5466 <- canbus_data %>%
  group_by(Time = Time5466) %>%
  summarize(mean.5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold = mean(`X5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold`, na.rm = TRUE),
            sd.5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold = sd(`X5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold`, na.rm = TRUE),
            max.5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold = ifelse(all(is.na(`X5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold`)), NA, max(`X5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold`, na.rm = TRUE)),
            min.5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold = ifelse(all(is.na(`X5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold`)), NA, min(`X5466.Aftertreatment.1.Diesel.Particulate.Filter.Soot.Load.Regeneration.Threshold`, na.rm = TRUE)))


downsampled_3721 <- canbus_data %>%
  group_by(Time = Time3721) %>%
  summarize(mean.3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration = mean(`X3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration`, na.rm = TRUE),
            sd.3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration = sd(`X3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration`, na.rm = TRUE),
            max.3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration = ifelse(all(is.na(`X3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration`)), NA, max(`X3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration`, na.rm = TRUE)),
            min.3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration = ifelse(all(is.na(`X3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration`)), NA, min(`X3721.Aftertreatment.1.Diesel.Particulate.Filter.Time.Since.Last.Active.Regeneration`, na.rm = TRUE)))


downsampled_3241 <- canbus_data %>%
  group_by(Time = Time3241) %>%
  summarize(mean.3241.Aftertreatment.1.Exhaust.Temperature.1 = mean(`X3241.Aftertreatment.1.Exhaust.Temperature.1`, na.rm = TRUE),
            sd.3241.Aftertreatment.1.Exhaust.Temperature.1 = sd(`X3241.Aftertreatment.1.Exhaust.Temperature.1`, na.rm = TRUE),
            max.3241.Aftertreatment.1.Exhaust.Temperature.1 = ifelse(all(is.na(`X3241.Aftertreatment.1.Exhaust.Temperature.1`)), NA, max(`X3241.Aftertreatment.1.Exhaust.Temperature.1`, na.rm = TRUE)),
            min.3241.Aftertreatment.1.Exhaust.Temperature.1 = ifelse(all(is.na(`X3241.Aftertreatment.1.Exhaust.Temperature.1`)), NA, min(`X3241.Aftertreatment.1.Exhaust.Temperature.1`, na.rm = TRUE)))


downsampled_3229 <- canbus_data %>%
  group_by(Time = Time3229) %>%
  summarize(mean.3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature = mean(`X3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature`, na.rm = TRUE),
            sd.3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature = sd(`X3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature`, na.rm = TRUE),
            max.3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature = ifelse(all(is.na(`X3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature`)), NA, max(`X3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature`, na.rm = TRUE)),
            min.3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature = ifelse(all(is.na(`X3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature`)), NA, min(`X3229.Aftertreatment.1.Outlet.Gas.Sensor.1.at.Temperature`, na.rm = TRUE)))


downsampled_3232 <- canbus_data %>%
  group_by(Time = Time3232) %>%
  summarize(mean.3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI = mean(`X3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI`, na.rm = TRUE),
            sd.3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI = sd(`X3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI`, na.rm = TRUE),
            max.3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI = ifelse(all(is.na(`X3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI`)), NA, max(`X3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI`, na.rm = TRUE)),
            min.3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI = ifelse(all(is.na(`X3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI`)), NA, min(`X3232.Aftertreatment.1.Outlet.Gas.Sensor.1.Heater.Preliminary.FMI`, na.rm = TRUE)))


downsampled_3226 <- canbus_data %>%
  group_by(Time = Time3226) %>%
  summarize(mean.3226.Aftertreatment.1.Outlet.NOx.1 = mean(`X3226.Aftertreatment.1.Outlet.NOx.1`, na.rm = TRUE),
            sd.3226.Aftertreatment.1.Outlet.NOx.1 = sd(`X3226.Aftertreatment.1.Outlet.NOx.1`, na.rm = TRUE),
            max.3226.Aftertreatment.1.Outlet.NOx.1 = ifelse(all(is.na(`X3226.Aftertreatment.1.Outlet.NOx.1`)), NA, max(`X3226.Aftertreatment.1.Outlet.NOx.1`, na.rm = TRUE)),
            min.3226.Aftertreatment.1.Outlet.NOx.1 = ifelse(all(is.na(`X3226.Aftertreatment.1.Outlet.NOx.1`)), NA, min(`X3226.Aftertreatment.1.Outlet.NOx.1`, na.rm = TRUE)))


downsampled_3230 <- canbus_data %>%
  group_by(Time = Time3230) %>%
  summarize(mean.3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable = mean(`X3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable`, na.rm = TRUE),
            sd.3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable = sd(`X3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable`, na.rm = TRUE),
            max.3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable = ifelse(all(is.na(`X3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable`)), NA, max(`X3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable`, na.rm = TRUE)),
            min.3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable = ifelse(all(is.na(`X3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable`)), NA, min(`X3230.Aftertreatment.1.Outlet.NOx.1.Reading.Stable`, na.rm = TRUE)))


downsampled_3231 <- canbus_data %>%
  group_by(Time = Time3231) %>%
  summarize(mean.3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable = mean(`X3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable`, na.rm = TRUE),
            sd.3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable = sd(`X3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable`, na.rm = TRUE),
            max.3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable = ifelse(all(is.na(`X3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable`)), NA, max(`X3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable`, na.rm = TRUE)),
            min.3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable = ifelse(all(is.na(`X3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable`)), NA, min(`X3231.Aftertreatment.1.Outlet.Wide.Range.Percent.Oxygen.1.Reading.Stable`, na.rm = TRUE)))


downsampled_4360 <- canbus_data %>%
  group_by(Time = Time4360) %>%
  summarize(mean.4360.Aftertreatment.1.SCR.Intake.Temperature = mean(`X4360.Aftertreatment.1.SCR.Intake.Temperature`, na.rm = TRUE),
            sd.4360.Aftertreatment.1.SCR.Intake.Temperature = sd(`X4360.Aftertreatment.1.SCR.Intake.Temperature`, na.rm = TRUE),
            max.4360.Aftertreatment.1.SCR.Intake.Temperature = ifelse(all(is.na(`X4360.Aftertreatment.1.SCR.Intake.Temperature`)), NA, max(`X4360.Aftertreatment.1.SCR.Intake.Temperature`, na.rm = TRUE)),
            min.4360.Aftertreatment.1.SCR.Intake.Temperature = ifelse(all(is.na(`X4360.Aftertreatment.1.SCR.Intake.Temperature`)), NA, min(`X4360.Aftertreatment.1.SCR.Intake.Temperature`, na.rm = TRUE)))


downsampled_5862 <- canbus_data %>%
  group_by(Time = Time5862) %>%
  summarize(mean.5862.Aftertreatment.1.SCR.Intermediate.Temperature = mean(`X5862.Aftertreatment.1.SCR.Intermediate.Temperature`, na.rm = TRUE),
            sd.5862.Aftertreatment.1.SCR.Intermediate.Temperature = sd(`X5862.Aftertreatment.1.SCR.Intermediate.Temperature`, na.rm = TRUE),
            max.5862.Aftertreatment.1.SCR.Intermediate.Temperature = ifelse(all(is.na(`X5862.Aftertreatment.1.SCR.Intermediate.Temperature`)), NA, max(`X5862.Aftertreatment.1.SCR.Intermediate.Temperature`, na.rm = TRUE)),
            min.5862.Aftertreatment.1.SCR.Intermediate.Temperature = ifelse(all(is.na(`X5862.Aftertreatment.1.SCR.Intermediate.Temperature`)), NA, min(`X5862.Aftertreatment.1.SCR.Intermediate.Temperature`, na.rm = TRUE)))


downsampled_4363 <- canbus_data %>%
  group_by(Time = Time4363) %>%
  summarize(mean.4363.Aftertreatment.1.SCR.Outlet.Temperature = mean(`X4363.Aftertreatment.1.SCR.Outlet.Temperature`, na.rm = TRUE),
            sd.4363.Aftertreatment.1.SCR.Outlet.Temperature = sd(`X4363.Aftertreatment.1.SCR.Outlet.Temperature`, na.rm = TRUE),
            max.4363.Aftertreatment.1.SCR.Outlet.Temperature = ifelse(all(is.na(`X4363.Aftertreatment.1.SCR.Outlet.Temperature`)), NA, max(`X4363.Aftertreatment.1.SCR.Outlet.Temperature`, na.rm = TRUE)),
            min.4363.Aftertreatment.1.SCR.Outlet.Temperature = ifelse(all(is.na(`X4363.Aftertreatment.1.SCR.Outlet.Temperature`)), NA, min(`X4363.Aftertreatment.1.SCR.Outlet.Temperature`, na.rm = TRUE)))


downsampled_3239 <- canbus_data %>%
  group_by(Time = Time3239) %>%
  summarize(mean.3239.Aftertreatment.2.Intake.Dew.Point = mean(`X3239.Aftertreatment.2.Intake.Dew.Point`, na.rm = TRUE),
            sd.3239.Aftertreatment.2.Intake.Dew.Point = sd(`X3239.Aftertreatment.2.Intake.Dew.Point`, na.rm = TRUE),
            max.3239.Aftertreatment.2.Intake.Dew.Point = ifelse(all(is.na(`X3239.Aftertreatment.2.Intake.Dew.Point`)), NA, max(`X3239.Aftertreatment.2.Intake.Dew.Point`, na.rm = TRUE)),
            min.3239.Aftertreatment.2.Intake.Dew.Point = ifelse(all(is.na(`X3239.Aftertreatment.2.Intake.Dew.Point`)), NA, min(`X3239.Aftertreatment.2.Intake.Dew.Point`, na.rm = TRUE)))

downsampled_171 <- canbus_data %>%
  group_by(Time = Time171) %>%
  summarize(mean.171.Ambient.Air.Temperature = mean(`X171.Ambient.Air.Temperature`, na.rm = TRUE),
            sd.171.Ambient.Air.Temperature = sd(`X171.Ambient.Air.Temperature`, na.rm = TRUE),
            max.171.Ambient.Air.Temperature = ifelse(all(is.na(`X171.Ambient.Air.Temperature`)), NA, max(`X171.Ambient.Air.Temperature`, na.rm = TRUE)),
            min.171.Ambient.Air.Temperature = ifelse(all(is.na(`X171.Ambient.Air.Temperature`)), NA, min(`X171.Ambient.Air.Temperature`, na.rm = TRUE)))


downsampled_108 <- canbus_data %>%
  group_by(Time = Time108) %>%
  summarize(mean.108.Barometric.Pressure = mean(`X108.Barometric.Pressure`, na.rm = TRUE),
            sd.108.Barometric.Pressure = sd(`X108.Barometric.Pressure`, na.rm = TRUE),
            max.108.Barometric.Pressure = ifelse(all(is.na(`X108.Barometric.Pressure`)), NA, max(`X108.Barometric.Pressure`, na.rm = TRUE)),
            min.108.Barometric.Pressure = ifelse(all(is.na(`X108.Barometric.Pressure`)), NA, min(`X108.Barometric.Pressure`, na.rm = TRUE)))


downsampled_168 <- canbus_data %>%
  group_by(Time = Time168) %>%
  summarize(mean.168.Battery.Potential...Power.Input.1 = mean(`X168.Battery.Potential...Power.Input.1`, na.rm = TRUE),
            sd.168.Battery.Potential...Power.Input.1 = sd(`X168.Battery.Potential...Power.Input.1`, na.rm = TRUE),
            max.168.Battery.Potential...Power.Input.1 = ifelse(all(is.na(`X168.Battery.Potential...Power.Input.1`)), NA, max(`X168.Battery.Potential...Power.Input.1`, na.rm = TRUE)),
            min.168.Battery.Potential...Power.Input.1 = ifelse(all(is.na(`X168.Battery.Potential...Power.Input.1`)), NA, min(`X168.Battery.Potential...Power.Input.1`, na.rm = TRUE)))


downsampled_117 <- canbus_data %>%
  group_by(Time = Time117) %>%
  summarize(mean.117.Brake.Primary.Pressure = mean(`X117.Brake.Primary.Pressure`, na.rm = TRUE),
            sd.117.Brake.Primary.Pressure = sd(`X117.Brake.Primary.Pressure`, na.rm = TRUE),
            max.117.Brake.Primary.Pressure = ifelse(all(is.na(`X117.Brake.Primary.Pressure`)), NA, max(`X117.Brake.Primary.Pressure`, na.rm = TRUE)),
            min.117.Brake.Primary.Pressure = ifelse(all(is.na(`X117.Brake.Primary.Pressure`)), NA, min(`X117.Brake.Primary.Pressure`, na.rm = TRUE)))


downsampled_118 <- canbus_data %>%
  group_by(Time = Time118) %>%
  summarize(mean.118.Brake.Secondary.Pressure = mean(`X118.Brake.Secondary.Pressure`, na.rm = TRUE),
            sd.118.Brake.Secondary.Pressure = sd(`X118.Brake.Secondary.Pressure`, na.rm = TRUE),
            max.118.Brake.Secondary.Pressure = ifelse(all(is.na(`X118.Brake.Secondary.Pressure`)), NA, max(`X118.Brake.Secondary.Pressure`, na.rm = TRUE)),
            min.118.Brake.Secondary.Pressure = ifelse(all(is.na(`X118.Brake.Secondary.Pressure`)), NA, min(`X118.Brake.Secondary.Pressure`, na.rm = TRUE)))


downsampled_5313 <- canbus_data %>%
  group_by(Time = Time5313) %>%
  summarize(mean.5313.Commanded.Engine.Fuel.Rail.Pressure = mean(`X5313.Commanded.Engine.Fuel.Rail.Pressure`, na.rm = TRUE),
            sd.5313.Commanded.Engine.Fuel.Rail.Pressure = sd(`X5313.Commanded.Engine.Fuel.Rail.Pressure`, na.rm = TRUE),
            max.5313.Commanded.Engine.Fuel.Rail.Pressure = ifelse(all(is.na(`X5313.Commanded.Engine.Fuel.Rail.Pressure`)), NA, max(`X5313.Commanded.Engine.Fuel.Rail.Pressure`, na.rm = TRUE)),
            min.5313.Commanded.Engine.Fuel.Rail.Pressure = ifelse(all(is.na(`X5313.Commanded.Engine.Fuel.Rail.Pressure`)), NA, min(`X5313.Commanded.Engine.Fuel.Rail.Pressure`, na.rm = TRUE)))


downsampled_7319 <- canbus_data %>%
  group_by(Time = Time7319) %>%
  summarize(mean.7319.Cruise.Control.Speed = mean(`X7319.Cruise.Control.Speed`, na.rm = TRUE),
            sd.7319.Cruise.Control.Speed = sd(`X7319.Cruise.Control.Speed`, na.rm = TRUE),
            max.7319.Cruise.Control.Speed = ifelse(all(is.na(`X7319.Cruise.Control.Speed`)), NA, max(`X7319.Cruise.Control.Speed`, na.rm = TRUE)),
            min.7319.Cruise.Control.Speed = ifelse(all(is.na(`X7319.Cruise.Control.Speed`)), NA, min(`X7319.Cruise.Control.Speed`, na.rm = TRUE)))


downsampled_512 <- canbus_data %>%
  group_by(Time = Time512) %>%
  summarize(mean.512.Driver.s.Demand.Engine...Percent.Torque = mean(`X512.Driver.s.Demand.Engine...Percent.Torque`, na.rm = TRUE),
            sd.512.Driver.s.Demand.Engine...Percent.Torque = sd(`X512.Driver.s.Demand.Engine...Percent.Torque`, na.rm = TRUE),
            max.512.Driver.s.Demand.Engine...Percent.Torque = ifelse(all(is.na(`X512.Driver.s.Demand.Engine...Percent.Torque`)), NA, max(`X512.Driver.s.Demand.Engine...Percent.Torque`, na.rm = TRUE)),
            min.512.Driver.s.Demand.Engine...Percent.Torque = ifelse(all(is.na(`X512.Driver.s.Demand.Engine...Percent.Torque`)), NA, min(`X512.Driver.s.Demand.Engine...Percent.Torque`, na.rm = TRUE)))


downsampled_515 <- canbus_data %>%
  group_by(Time = Time515) %>%
  summarize(mean.515.Engine.s.Desired.Operating.Speed = mean(`X515.Engine.s.Desired.Operating.Speed`, na.rm = TRUE),
            sd.515.Engine.s.Desired.Operating.Speed = sd(`X515.Engine.s.Desired.Operating.Speed`, na.rm = TRUE),
            max.515.Engine.s.Desired.Operating.Speed = ifelse(all(is.na(`X515.Engine.s.Desired.Operating.Speed`)), NA, max(`X515.Engine.s.Desired.Operating.Speed`, na.rm = TRUE)),
            min.515.Engine.s.Desired.Operating.Speed = ifelse(all(is.na(`X515.Engine.s.Desired.Operating.Speed`)), NA, min(`X515.Engine.s.Desired.Operating.Speed`, na.rm = TRUE)))


downsampled_185 <- canbus_data %>%
  group_by(Time = Time185) %>%
  summarize(mean.185.Engine.Average.Fuel.Economy = mean(`X185.Engine.Average.Fuel.Economy`, na.rm = TRUE),
            sd.185.Engine.Average.Fuel.Economy = sd(`X185.Engine.Average.Fuel.Economy`, na.rm = TRUE),
            max.185.Engine.Average.Fuel.Economy = ifelse(all(is.na(`X185.Engine.Average.Fuel.Economy`)), NA, max(`X185.Engine.Average.Fuel.Economy`, na.rm = TRUE)),
            min.185.Engine.Average.Fuel.Economy = ifelse(all(is.na(`X185.Engine.Average.Fuel.Economy`)), NA, min(`X185.Engine.Average.Fuel.Economy`, na.rm = TRUE)))


downsampled_110 <- canbus_data %>%
  group_by(Time = Time110) %>%
  summarize(mean.110.Engine.Coolant.Temperature = mean(`X110.Engine.Coolant.Temperature`, na.rm = TRUE),
            sd.110.Engine.Coolant.Temperature = sd(`X110.Engine.Coolant.Temperature`, na.rm = TRUE),
            max.110.Engine.Coolant.Temperature = ifelse(all(is.na(`X110.Engine.Coolant.Temperature`)), NA, max(`X110.Engine.Coolant.Temperature`, na.rm = TRUE)),
            min.110.Engine.Coolant.Temperature = ifelse(all(is.na(`X110.Engine.Coolant.Temperature`)), NA, min(`X110.Engine.Coolant.Temperature`, na.rm = TRUE)))


downsampled_101 <- canbus_data %>%
  group_by(Time = Time101) %>%
  summarize(mean.101.Engine.Crankcase.Pressure.1 = mean(`X101.Engine.Crankcase.Pressure.1`, na.rm = TRUE),
            sd.101.Engine.Crankcase.Pressure.1 = sd(`X101.Engine.Crankcase.Pressure.1`, na.rm = TRUE),
            max.101.Engine.Crankcase.Pressure.1 = ifelse(all(is.na(`X101.Engine.Crankcase.Pressure.1`)), NA, max(`X101.Engine.Crankcase.Pressure.1`, na.rm = TRUE)),
            min.101.Engine.Crankcase.Pressure.1 = ifelse(all(is.na(`X101.Engine.Crankcase.Pressure.1`)), NA, min(`X101.Engine.Crankcase.Pressure.1`, na.rm = TRUE)))


downsampled_2432 <- canbus_data %>%
  group_by(Time = Time2432) %>%
  summarize(mean.2432.Engine.Demand...Percent.Torque = mean(`X2432.Engine.Demand...Percent.Torque`, na.rm = TRUE),
            sd.2432.Engine.Demand...Percent.Torque = sd(`X2432.Engine.Demand...Percent.Torque`, na.rm = TRUE),
            max.2432.Engine.Demand...Percent.Torque = ifelse(all(is.na(`X2432.Engine.Demand...Percent.Torque`)), NA, max(`X2432.Engine.Demand...Percent.Torque`, na.rm = TRUE)),
            min.2432.Engine.Demand...Percent.Torque = ifelse(all(is.na(`X2432.Engine.Demand...Percent.Torque`)), NA, min(`X2432.Engine.Demand...Percent.Torque`, na.rm = TRUE)))


downsampled_1136 <- canbus_data %>%
  group_by(Time = Time1136) %>%
  summarize(mean.1136.Engine.ECU.Temperature = mean(`X1136.Engine.ECU.Temperature`, na.rm = TRUE),
            sd.1136.Engine.ECU.Temperature = sd(`X1136.Engine.ECU.Temperature`, na.rm = TRUE),
            max.1136.Engine.ECU.Temperature = ifelse(all(is.na(`X1136.Engine.ECU.Temperature`)), NA, max(`X1136.Engine.ECU.Temperature`, na.rm = TRUE)),
            min.1136.Engine.ECU.Temperature = ifelse(all(is.na(`X1136.Engine.ECU.Temperature`)), NA, min(`X1136.Engine.ECU.Temperature`, na.rm = TRUE)))


downsampled_3216 <- canbus_data %>%
  group_by(Time = Time3216) %>%
  summarize(mean.3216.Engine.Exhaust.1.NOx.1 = mean(`X3216.Engine.Exhaust.1.NOx.1`, na.rm = TRUE),
            sd.3216.Engine.Exhaust.1.NOx.1 = sd(`X3216.Engine.Exhaust.1.NOx.1`, na.rm = TRUE),
            max.3216.Engine.Exhaust.1.NOx.1 = ifelse(all(is.na(`X3216.Engine.Exhaust.1.NOx.1`)), NA, max(`X3216.Engine.Exhaust.1.NOx.1`, na.rm = TRUE)),
            min.3216.Engine.Exhaust.1.NOx.1 = ifelse(all(is.na(`X3216.Engine.Exhaust.1.NOx.1`)), NA, min(`X3216.Engine.Exhaust.1.NOx.1`, na.rm = TRUE)))


downsampled_1209 <- canbus_data %>%
  group_by(Time = Time1209) %>%
  summarize(mean.1209.Engine.Exhaust.Bank.1.Pressure.1 = mean(`X1209.Engine.Exhaust.Bank.1.Pressure.1`, na.rm = TRUE),
            sd.1209.Engine.Exhaust.Bank.1.Pressure.1 = sd(`X1209.Engine.Exhaust.Bank.1.Pressure.1`, na.rm = TRUE),
            max.1209.Engine.Exhaust.Bank.1.Pressure.1 = ifelse(all(is.na(`X1209.Engine.Exhaust.Bank.1.Pressure.1`)), NA, max(`X1209.Engine.Exhaust.Bank.1.Pressure.1`, na.rm = TRUE)),
            min.1209.Engine.Exhaust.Bank.1.Pressure.1 = ifelse(all(is.na(`X1209.Engine.Exhaust.Bank.1.Pressure.1`)), NA, min(`X1209.Engine.Exhaust.Bank.1.Pressure.1`, na.rm = TRUE)))


downsampled_2659 <- canbus_data %>%
  group_by(Time = Time2659) %>%
  summarize(mean.2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate = mean(`X2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate`, na.rm = TRUE),
            sd.2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate = sd(`X2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate`, na.rm = TRUE),
            max.2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate = ifelse(all(is.na(`X2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate`)), NA, max(`X2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate`, na.rm = TRUE)),
            min.2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate = ifelse(all(is.na(`X2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate`)), NA, min(`X2659.Engine.Exhaust.Gas.Recirculation.1.Mass.Flow.Rate`, na.rm = TRUE)))


downsampled_412 <- canbus_data %>%
  group_by(Time = Time412) %>%
  summarize(mean.412.Engine.Exhaust.Gas.Recirculation.1.Temperature = mean(`X412.Engine.Exhaust.Gas.Recirculation.1.Temperature`, na.rm = TRUE),
            sd.412.Engine.Exhaust.Gas.Recirculation.1.Temperature = sd(`X412.Engine.Exhaust.Gas.Recirculation.1.Temperature`, na.rm = TRUE),
            max.412.Engine.Exhaust.Gas.Recirculation.1.Temperature = ifelse(all(is.na(`X412.Engine.Exhaust.Gas.Recirculation.1.Temperature`)), NA, max(`X412.Engine.Exhaust.Gas.Recirculation.1.Temperature`, na.rm = TRUE)),
            min.412.Engine.Exhaust.Gas.Recirculation.1.Temperature = ifelse(all(is.na(`X412.Engine.Exhaust.Gas.Recirculation.1.Temperature`)), NA, min(`X412.Engine.Exhaust.Gas.Recirculation.1.Temperature`, na.rm = TRUE)))


downsampled_27 <- canbus_data %>%
  group_by(Time = Time27) %>%
  summarize(mean.27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position = mean(`X27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position`, na.rm = TRUE),
            sd.27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position = sd(`X27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position`, na.rm = TRUE),
            max.27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position = ifelse(all(is.na(`X27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position`)), NA, max(`X27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position`, na.rm = TRUE)),
            min.27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position = ifelse(all(is.na(`X27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position`)), NA, min(`X27.Engine.Exhaust.Gas.Recirculation.1.Valve.Position`, na.rm = TRUE)))


downsampled_975 <- canbus_data %>%
  group_by(Time = Time975) %>%
  summarize(mean.975.Engine.Fan.1.Estimated.Percent.Speed = mean(`X975.Engine.Fan.1.Estimated.Percent.Speed`, na.rm = TRUE),
            sd.975.Engine.Fan.1.Estimated.Percent.Speed = sd(`X975.Engine.Fan.1.Estimated.Percent.Speed`, na.rm = TRUE),
            max.975.Engine.Fan.1.Estimated.Percent.Speed = ifelse(all(is.na(`X975.Engine.Fan.1.Estimated.Percent.Speed`)), NA, max(`X975.Engine.Fan.1.Estimated.Percent.Speed`, na.rm = TRUE)),
            min.975.Engine.Fan.1.Estimated.Percent.Speed = ifelse(all(is.na(`X975.Engine.Fan.1.Estimated.Percent.Speed`)), NA, min(`X975.Engine.Fan.1.Estimated.Percent.Speed`, na.rm = TRUE)))


downsampled_986 <- canbus_data %>%
  group_by(Time = Time986) %>%
  summarize(mean.986.Engine.Fan.1.Requested.Percent.Speed = mean(`X986.Engine.Fan.1.Requested.Percent.Speed`, na.rm = TRUE),
            sd.986.Engine.Fan.1.Requested.Percent.Speed = sd(`X986.Engine.Fan.1.Requested.Percent.Speed`, na.rm = TRUE),
            max.986.Engine.Fan.1.Requested.Percent.Speed = ifelse(all(is.na(`X986.Engine.Fan.1.Requested.Percent.Speed`)), NA, max(`X986.Engine.Fan.1.Requested.Percent.Speed`, na.rm = TRUE)),
            min.986.Engine.Fan.1.Requested.Percent.Speed = ifelse(all(is.na(`X986.Engine.Fan.1.Requested.Percent.Speed`)), NA, min(`X986.Engine.Fan.1.Requested.Percent.Speed`, na.rm = TRUE)))


downsampled_157 <- canbus_data %>%
  group_by(Time = Time157) %>%
  summarize(mean.157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure = mean(`X157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure`, na.rm = TRUE),
            sd.157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure = sd(`X157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure`, na.rm = TRUE),
            max.157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure = ifelse(all(is.na(`X157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure`)), NA, max(`X157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure`, na.rm = TRUE)),
            min.157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure = ifelse(all(is.na(`X157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure`)), NA, min(`X157.Engine.Fuel.1.Injector.Metering.Rail.1.Pressure`, na.rm = TRUE)))


downsampled_183 <- canbus_data %>%
  group_by(Time = Time183) %>%
  summarize(mean.183.Engine.Fuel.Rate = mean(`X183.Engine.Fuel.Rate`, na.rm = TRUE),
            sd.183.Engine.Fuel.Rate = sd(`X183.Engine.Fuel.Rate`, na.rm = TRUE),
            max.183.Engine.Fuel.Rate = ifelse(all(is.na(`X183.Engine.Fuel.Rate`)), NA, max(`X183.Engine.Fuel.Rate`, na.rm = TRUE)),
            min.183.Engine.Fuel.Rate = ifelse(all(is.na(`X183.Engine.Fuel.Rate`)), NA, min(`X183.Engine.Fuel.Rate`, na.rm = TRUE)))


downsampled_184 <- canbus_data %>%
  group_by(Time = Time184) %>%
  summarize(mean.184.Engine.Instantaneous.Fuel.Economy = mean(`X184.Engine.Instantaneous.Fuel.Economy`, na.rm = TRUE),
            sd.184.Engine.Instantaneous.Fuel.Economy = sd(`X184.Engine.Instantaneous.Fuel.Economy`, na.rm = TRUE),
            max.184.Engine.Instantaneous.Fuel.Economy = ifelse(all(is.na(`X184.Engine.Instantaneous.Fuel.Economy`)), NA, max(`X184.Engine.Instantaneous.Fuel.Economy`, na.rm = TRUE)),
            min.184.Engine.Instantaneous.Fuel.Economy = ifelse(all(is.na(`X184.Engine.Instantaneous.Fuel.Economy`)), NA, min(`X184.Engine.Instantaneous.Fuel.Economy`, na.rm = TRUE)))


downsampled_132 <- canbus_data %>%
  group_by(Time = Time132) %>%
  summarize(mean.132.Engine.Intake.Air.Mass.Flow.Rate = mean(`X132.Engine.Intake.Air.Mass.Flow.Rate`, na.rm = TRUE),
            sd.132.Engine.Intake.Air.Mass.Flow.Rate = sd(`X132.Engine.Intake.Air.Mass.Flow.Rate`, na.rm = TRUE),
            max.132.Engine.Intake.Air.Mass.Flow.Rate = ifelse(all(is.na(`X132.Engine.Intake.Air.Mass.Flow.Rate`)), NA, max(`X132.Engine.Intake.Air.Mass.Flow.Rate`, na.rm = TRUE)),
            min.132.Engine.Intake.Air.Mass.Flow.Rate = ifelse(all(is.na(`X132.Engine.Intake.Air.Mass.Flow.Rate`)), NA, min(`X132.Engine.Intake.Air.Mass.Flow.Rate`, na.rm = TRUE)))


downsampled_102 <- canbus_data %>%
  group_by(Time = Time102) %>%
  summarize(mean.102.Engine.Intake.Manifold..1.Pressure = mean(`X102.Engine.Intake.Manifold..1.Pressure`, na.rm = TRUE),
            sd.102.Engine.Intake.Manifold..1.Pressure = sd(`X102.Engine.Intake.Manifold..1.Pressure`, na.rm = TRUE),
            max.102.Engine.Intake.Manifold..1.Pressure = ifelse(all(is.na(`X102.Engine.Intake.Manifold..1.Pressure`)), NA, max(`X102.Engine.Intake.Manifold..1.Pressure`, na.rm = TRUE)),
            min.102.Engine.Intake.Manifold..1.Pressure = ifelse(all(is.na(`X102.Engine.Intake.Manifold..1.Pressure`)), NA, min(`X102.Engine.Intake.Manifold..1.Pressure`, na.rm = TRUE)))


downsampled_105 <- canbus_data %>%
  group_by(Time = Time105) %>%
  summarize(mean.105.Engine.Intake.Manifold.1.Temperature = mean(`X105.Engine.Intake.Manifold.1.Temperature`, na.rm = TRUE),
            sd.105.Engine.Intake.Manifold.1.Temperature = sd(`X105.Engine.Intake.Manifold.1.Temperature`, na.rm = TRUE),
            max.105.Engine.Intake.Manifold.1.Temperature = ifelse(all(is.na(`X105.Engine.Intake.Manifold.1.Temperature`)), NA, max(`X105.Engine.Intake.Manifold.1.Temperature`, na.rm = TRUE)),
            min.105.Engine.Intake.Manifold.1.Temperature = ifelse(all(is.na(`X105.Engine.Intake.Manifold.1.Temperature`)), NA, min(`X105.Engine.Intake.Manifold.1.Temperature`, na.rm = TRUE)))


downsampled_100 <- canbus_data %>%
  group_by(Time = Time100) %>%
  summarize(mean.100.Engine.Oil.Pressure.1 = mean(`X100.Engine.Oil.Pressure.1`, na.rm = TRUE),
            sd.100.Engine.Oil.Pressure.1 = sd(`X100.Engine.Oil.Pressure.1`, na.rm = TRUE),
            max.100.Engine.Oil.Pressure.1 = ifelse(all(is.na(`X100.Engine.Oil.Pressure.1`)), NA, max(`X100.Engine.Oil.Pressure.1`, na.rm = TRUE)),
            min.100.Engine.Oil.Pressure.1 = ifelse(all(is.na(`X100.Engine.Oil.Pressure.1`)), NA, min(`X100.Engine.Oil.Pressure.1`, na.rm = TRUE)))


downsampled_92 <- canbus_data %>%
  group_by(Time = Time92) %>%
  summarize(mean.92.Engine.Percent.Load.At.Current.Speed = mean(`X92.Engine.Percent.Load.At.Current.Speed`, na.rm = TRUE),
            sd.92.Engine.Percent.Load.At.Current.Speed = sd(`X92.Engine.Percent.Load.At.Current.Speed`, na.rm = TRUE),
            max.92.Engine.Percent.Load.At.Current.Speed = ifelse(all(is.na(`X92.Engine.Percent.Load.At.Current.Speed`)), NA, max(`X92.Engine.Percent.Load.At.Current.Speed`, na.rm = TRUE)),
            min.92.Engine.Percent.Load.At.Current.Speed = ifelse(all(is.na(`X92.Engine.Percent.Load.At.Current.Speed`)), NA, min(`X92.Engine.Percent.Load.At.Current.Speed`, na.rm = TRUE)))


downsampled_898 <- canbus_data %>%
  group_by(Time = Time898) %>%
  summarize(mean.898.Engine.Requested.Speed.Speed.Limit = mean(`X898.Engine.Requested.Speed.Speed.Limit`, na.rm = TRUE),
            sd.898.Engine.Requested.Speed.Speed.Limit = sd(`X898.Engine.Requested.Speed.Speed.Limit`, na.rm = TRUE),
            max.898.Engine.Requested.Speed.Speed.Limit = ifelse(all(is.na(`X898.Engine.Requested.Speed.Speed.Limit`)), NA, max(`X898.Engine.Requested.Speed.Speed.Limit`, na.rm = TRUE)),
            min.898.Engine.Requested.Speed.Speed.Limit = ifelse(all(is.na(`X898.Engine.Requested.Speed.Speed.Limit`)), NA, min(`X898.Engine.Requested.Speed.Speed.Limit`, na.rm = TRUE)))


downsampled_4191 <- canbus_data %>%
  group_by(Time = Time4191) %>%
  summarize(mean.4191.Engine.Requested.Torque..Fractional. = mean(`X4191.Engine.Requested.Torque..Fractional.`, na.rm = TRUE),
            sd.4191.Engine.Requested.Torque..Fractional. = sd(`X4191.Engine.Requested.Torque..Fractional.`, na.rm = TRUE),
            max.4191.Engine.Requested.Torque..Fractional. = ifelse(all(is.na(`X4191.Engine.Requested.Torque..Fractional.`)), NA, max(`X4191.Engine.Requested.Torque..Fractional.`, na.rm = TRUE)),
            min.4191.Engine.Requested.Torque..Fractional. = ifelse(all(is.na(`X4191.Engine.Requested.Torque..Fractional.`)), NA, min(`X4191.Engine.Requested.Torque..Fractional.`, na.rm = TRUE)))


downsampled_518 <- canbus_data %>%
  group_by(Time = Time518) %>%
  summarize(mean.518.Engine.Requested.Torque.Torque.Limit = mean(`X518.Engine.Requested.Torque.Torque.Limit`, na.rm = TRUE),
            sd.518.Engine.Requested.Torque.Torque.Limit = sd(`X518.Engine.Requested.Torque.Torque.Limit`, na.rm = TRUE),
            max.518.Engine.Requested.Torque.Torque.Limit = ifelse(all(is.na(`X518.Engine.Requested.Torque.Torque.Limit`)), NA, max(`X518.Engine.Requested.Torque.Torque.Limit`, na.rm = TRUE)),
            min.518.Engine.Requested.Torque.Torque.Limit = ifelse(all(is.na(`X518.Engine.Requested.Torque.Torque.Limit`)), NA, min(`X518.Engine.Requested.Torque.Torque.Limit`, na.rm = TRUE)))


downsampled_190 <- canbus_data %>%
  group_by(Time = Time190) %>%
  summarize(mean.190.Engine.Speed = mean(`X190.Engine.Speed`, na.rm = TRUE),
            sd.190.Engine.Speed = sd(`X190.Engine.Speed`, na.rm = TRUE),
            max.190.Engine.Speed = ifelse(all(is.na(`X190.Engine.Speed`)), NA, max(`X190.Engine.Speed`, na.rm = TRUE)),
            min.190.Engine.Speed = ifelse(all(is.na(`X190.Engine.Speed`)), NA, min(`X190.Engine.Speed`, na.rm = TRUE)))

downsampled_190CAN0 <- canbus_data %>%
  group_by(Time = Time190.CAN0) %>%
  summarize(mean.190.Engine.Speed.CAN0 = mean(`X190.Engine.Speed.CAN0`, na.rm = TRUE),
            sd.190.Engine.Speed.CAN0 = sd(`X190.Engine.Speed.CAN0`, na.rm = TRUE),
            max.190.Engine.Speed.CAN0 = ifelse(all(is.na(`X190.Engine.Speed.CAN0`)), NA, max(`X190.Engine.Speed.CAN0`, na.rm = TRUE)),
            min.190.Engine.Speed.CAN0 = ifelse(all(is.na(`X190.Engine.Speed.CAN0`)), NA, min(`X190.Engine.Speed.CAN0`, na.rm = TRUE)))


downsampled_51 <- canbus_data %>%
  group_by(Time = Time51) %>%
  summarize(mean.51.Engine.Throttle.Valve.1.Position.1 = mean(`X51.Engine.Throttle.Valve.1.Position.1`, na.rm = TRUE),
            sd.51.Engine.Throttle.Valve.1.Position.1 = sd(`X51.Engine.Throttle.Valve.1.Position.1`, na.rm = TRUE),
            max.51.Engine.Throttle.Valve.1.Position.1 = ifelse(all(is.na(`X51.Engine.Throttle.Valve.1.Position.1`)), NA, max(`X51.Engine.Throttle.Valve.1.Position.1`, na.rm = TRUE)),
            min.51.Engine.Throttle.Valve.1.Position.1 = ifelse(all(is.na(`X51.Engine.Throttle.Valve.1.Position.1`)), NA, min(`X51.Engine.Throttle.Valve.1.Position.1`, na.rm = TRUE)))


downsampled_250 <- canbus_data %>%
  group_by(Time = Time250) %>%
  summarize(mean.250.Engine.Total.Fuel.Used = mean(`X250.Engine.Total.Fuel.Used`, na.rm = TRUE),
            sd.250.Engine.Total.Fuel.Used = sd(`X250.Engine.Total.Fuel.Used`, na.rm = TRUE),
            max.250.Engine.Total.Fuel.Used = ifelse(all(is.na(`X250.Engine.Total.Fuel.Used`)), NA, max(`X250.Engine.Total.Fuel.Used`, na.rm = TRUE)),
            min.250.Engine.Total.Fuel.Used = ifelse(all(is.na(`X250.Engine.Total.Fuel.Used`)), NA, min(`X250.Engine.Total.Fuel.Used`, na.rm = TRUE)))


downsampled_247 <- canbus_data %>%
  group_by(Time = Time247) %>%
  summarize(mean.247.Engine.Total.Hours.of.Operation = mean(`X247.Engine.Total.Hours.of.Operation`, na.rm = TRUE),
            sd.247.Engine.Total.Hours.of.Operation = sd(`X247.Engine.Total.Hours.of.Operation`, na.rm = TRUE),
            max.247.Engine.Total.Hours.of.Operation = ifelse(all(is.na(`X247.Engine.Total.Hours.of.Operation`)), NA, max(`X247.Engine.Total.Hours.of.Operation`, na.rm = TRUE)),
            min.247.Engine.Total.Hours.of.Operation = ifelse(all(is.na(`X247.Engine.Total.Hours.of.Operation`)), NA, min(`X247.Engine.Total.Hours.of.Operation`, na.rm = TRUE)))


downsampled_236 <- canbus_data %>%
  group_by(Time = Time236) %>%
  summarize(mean.236.Engine.Total.Idle.Fuel.Used = mean(`X236.Engine.Total.Idle.Fuel.Used`, na.rm = TRUE),
            sd.236.Engine.Total.Idle.Fuel.Used = sd(`X236.Engine.Total.Idle.Fuel.Used`, na.rm = TRUE),
            max.236.Engine.Total.Idle.Fuel.Used = ifelse(all(is.na(`X236.Engine.Total.Idle.Fuel.Used`)), NA, max(`X236.Engine.Total.Idle.Fuel.Used`, na.rm = TRUE)),
            min.236.Engine.Total.Idle.Fuel.Used = ifelse(all(is.na(`X236.Engine.Total.Idle.Fuel.Used`)), NA, min(`X236.Engine.Total.Idle.Fuel.Used`, na.rm = TRUE)))


downsampled_235 <- canbus_data %>%
  group_by(Time = Time235) %>%
  summarize(mean.235.Engine.Total.Idle.Hours = mean(`X235.Engine.Total.Idle.Hours`, na.rm = TRUE),
            sd.235.Engine.Total.Idle.Hours = sd(`X235.Engine.Total.Idle.Hours`, na.rm = TRUE),
            max.235.Engine.Total.Idle.Hours = ifelse(all(is.na(`X235.Engine.Total.Idle.Hours`)), NA, max(`X235.Engine.Total.Idle.Hours`, na.rm = TRUE)),
            min.235.Engine.Total.Idle.Hours = ifelse(all(is.na(`X235.Engine.Total.Idle.Hours`)), NA, min(`X235.Engine.Total.Idle.Hours`, na.rm = TRUE)))


downsampled_249 <- canbus_data %>%
  group_by(Time = Time249) %>%
  summarize(mean.249.Engine.Total.Revolutions = mean(`X249.Engine.Total.Revolutions`, na.rm = TRUE),
            sd.249.Engine.Total.Revolutions = sd(`X249.Engine.Total.Revolutions`, na.rm = TRUE),
            max.249.Engine.Total.Revolutions = ifelse(all(is.na(`X249.Engine.Total.Revolutions`)), NA, max(`X249.Engine.Total.Revolutions`, na.rm = TRUE)),
            min.249.Engine.Total.Revolutions = ifelse(all(is.na(`X249.Engine.Total.Revolutions`)), NA, min(`X249.Engine.Total.Revolutions`, na.rm = TRUE)))


downsampled_182 <- canbus_data %>%
  group_by(Time = Time182) %>%
  summarize(mean.182.Engine.Trip.Fuel = mean(`X182.Engine.Trip.Fuel`, na.rm = TRUE),
            sd.182.Engine.Trip.Fuel = sd(`X182.Engine.Trip.Fuel`, na.rm = TRUE),
            max.182.Engine.Trip.Fuel = ifelse(all(is.na(`X182.Engine.Trip.Fuel`)), NA, max(`X182.Engine.Trip.Fuel`, na.rm = TRUE)),
            min.182.Engine.Trip.Fuel = ifelse(all(is.na(`X182.Engine.Trip.Fuel`)), NA, min(`X182.Engine.Trip.Fuel`, na.rm = TRUE)))


downsampled_1172 <- canbus_data %>%
  group_by(Time = Time1172) %>%
  summarize(mean.1172.Engine.Turbocharger.1.Compressor.Intake.Temperature = mean(`X1172.Engine.Turbocharger.1.Compressor.Intake.Temperature`, na.rm = TRUE),
            sd.1172.Engine.Turbocharger.1.Compressor.Intake.Temperature = sd(`X1172.Engine.Turbocharger.1.Compressor.Intake.Temperature`, na.rm = TRUE),
            max.1172.Engine.Turbocharger.1.Compressor.Intake.Temperature = ifelse(all(is.na(`X1172.Engine.Turbocharger.1.Compressor.Intake.Temperature`)), NA, max(`X1172.Engine.Turbocharger.1.Compressor.Intake.Temperature`, na.rm = TRUE)),
            min.1172.Engine.Turbocharger.1.Compressor.Intake.Temperature = ifelse(all(is.na(`X1172.Engine.Turbocharger.1.Compressor.Intake.Temperature`)), NA, min(`X1172.Engine.Turbocharger.1.Compressor.Intake.Temperature`, na.rm = TRUE)))


downsampled_103 <- canbus_data %>%
  group_by(Time = Time103) %>%
  summarize(mean.103.Engine.Turbocharger.1.Speed = mean(`X103.Engine.Turbocharger.1.Speed`, na.rm = TRUE),
            sd.103.Engine.Turbocharger.1.Speed = sd(`X103.Engine.Turbocharger.1.Speed`, na.rm = TRUE),
            max.103.Engine.Turbocharger.1.Speed = ifelse(all(is.na(`X103.Engine.Turbocharger.1.Speed`)), NA, max(`X103.Engine.Turbocharger.1.Speed`, na.rm = TRUE)),
            min.103.Engine.Turbocharger.1.Speed = ifelse(all(is.na(`X103.Engine.Turbocharger.1.Speed`)), NA, min(`X103.Engine.Turbocharger.1.Speed`, na.rm = TRUE)))


downsampled_641 <- canbus_data %>%
  group_by(Time = Time641) %>%
  summarize(mean.641.Engine.Variable.Geometry.Turbocharger.Actuator..1 = mean(`X641.Engine.Variable.Geometry.Turbocharger.Actuator..1`, na.rm = TRUE),
            sd.641.Engine.Variable.Geometry.Turbocharger.Actuator..1 = sd(`X641.Engine.Variable.Geometry.Turbocharger.Actuator..1`, na.rm = TRUE),
            max.641.Engine.Variable.Geometry.Turbocharger.Actuator..1 = ifelse(all(is.na(`X641.Engine.Variable.Geometry.Turbocharger.Actuator..1`)), NA, max(`X641.Engine.Variable.Geometry.Turbocharger.Actuator..1`, na.rm = TRUE)),
            min.641.Engine.Variable.Geometry.Turbocharger.Actuator..1 = ifelse(all(is.na(`X641.Engine.Variable.Geometry.Turbocharger.Actuator..1`)), NA, min(`X641.Engine.Variable.Geometry.Turbocharger.Actuator..1`, na.rm = TRUE)))


downsampled_2978 <- canbus_data %>%
  group_by(Time = Time2978) %>%
  summarize(mean.2978.Estimated.Engine.Parasitic.Losses...Percent.Torque = mean(`X2978.Estimated.Engine.Parasitic.Losses...Percent.Torque`, na.rm = TRUE),
            sd.2978.Estimated.Engine.Parasitic.Losses...Percent.Torque = sd(`X2978.Estimated.Engine.Parasitic.Losses...Percent.Torque`, na.rm = TRUE),
            max.2978.Estimated.Engine.Parasitic.Losses...Percent.Torque = ifelse(all(is.na(`X2978.Estimated.Engine.Parasitic.Losses...Percent.Torque`)), NA, max(`X2978.Estimated.Engine.Parasitic.Losses...Percent.Torque`, na.rm = TRUE)),
            min.2978.Estimated.Engine.Parasitic.Losses...Percent.Torque = ifelse(all(is.na(`X2978.Estimated.Engine.Parasitic.Losses...Percent.Torque`)), NA, min(`X2978.Estimated.Engine.Parasitic.Losses...Percent.Torque`, na.rm = TRUE)))


downsampled_5398 <- canbus_data %>%
  group_by(Time = Time5398) %>%
  summarize(mean.5398.Estimated.Pumping...Percent.Torque = mean(`X5398.Estimated.Pumping...Percent.Torque`, na.rm = TRUE),
            sd.5398.Estimated.Pumping...Percent.Torque = sd(`X5398.Estimated.Pumping...Percent.Torque`, na.rm = TRUE),
            max.5398.Estimated.Pumping...Percent.Torque = ifelse(all(is.na(`X5398.Estimated.Pumping...Percent.Torque`)), NA, max(`X5398.Estimated.Pumping...Percent.Torque`, na.rm = TRUE)),
            min.5398.Estimated.Pumping...Percent.Torque = ifelse(all(is.na(`X5398.Estimated.Pumping...Percent.Torque`)), NA, min(`X5398.Estimated.Pumping...Percent.Torque`, na.rm = TRUE)))


downsampled_904 <- canbus_data %>%
  group_by(Time = Time904) %>%
  summarize(mean.904.Front.Axle.Speed = mean(`X904.Front.Axle.Speed`, na.rm = TRUE),
            sd.904.Front.Axle.Speed = sd(`X904.Front.Axle.Speed`, na.rm = TRUE),
            max.904.Front.Axle.Speed = ifelse(all(is.na(`X904.Front.Axle.Speed`)), NA, max(`X904.Front.Axle.Speed`, na.rm = TRUE)),
            min.904.Front.Axle.Speed = ifelse(all(is.na(`X904.Front.Axle.Speed`)), NA, min(`X904.Front.Axle.Speed`, na.rm = TRUE)))


downsampled_96 <- canbus_data %>%
  group_by(Time = Time96) %>%
  summarize(mean.96.Fuel.Level.1 = mean(`X96.Fuel.Level.1`, na.rm = TRUE),
            sd.96.Fuel.Level.1 = sd(`X96.Fuel.Level.1`, na.rm = TRUE),
            max.96.Fuel.Level.1 = ifelse(all(is.na(`X96.Fuel.Level.1`)), NA, max(`X96.Fuel.Level.1`, na.rm = TRUE)),
            min.96.Fuel.Level.1 = ifelse(all(is.na(`X96.Fuel.Level.1`)), NA, min(`X96.Fuel.Level.1`, na.rm = TRUE)))


downsampled_1242 <- canbus_data %>%
  group_by(Time = Time1242) %>%
  summarize(mean.1242.Instantaneous.Estimated.Brake.Power = mean(`X1242.Instantaneous.Estimated.Brake.Power`, na.rm = TRUE),
            sd.1242.Instantaneous.Estimated.Brake.Power = sd(`X1242.Instantaneous.Estimated.Brake.Power`, na.rm = TRUE),
            max.1242.Instantaneous.Estimated.Brake.Power = ifelse(all(is.na(`X1242.Instantaneous.Estimated.Brake.Power`)), NA, max(`X1242.Instantaneous.Estimated.Brake.Power`, na.rm = TRUE)),
            min.1242.Instantaneous.Estimated.Brake.Power = ifelse(all(is.na(`X1242.Instantaneous.Estimated.Brake.Power`)), NA, min(`X1242.Instantaneous.Estimated.Brake.Power`, na.rm = TRUE)))


downsampled_4207 <- canbus_data %>%
  group_by(Time = Time4207) %>%
  summarize(mean.4207.Message.Checksum = mean(`X4207.Message.Checksum`, na.rm = TRUE),
            sd.4207.Message.Checksum = sd(`X4207.Message.Checksum`, na.rm = TRUE),
            max.4207.Message.Checksum = ifelse(all(is.na(`X4207.Message.Checksum`)), NA, max(`X4207.Message.Checksum`, na.rm = TRUE)),
            min.4207.Message.Checksum = ifelse(all(is.na(`X4207.Message.Checksum`)), NA, min(`X4207.Message.Checksum`, na.rm = TRUE)))


downsampled_4206 <- canbus_data %>%
  group_by(Time = Time4206) %>%
  summarize(mean.4206.Message.Counter = mean(`X4206.Message.Counter`, na.rm = TRUE),
            sd.4206.Message.Counter = sd(`X4206.Message.Counter`, na.rm = TRUE),
            max.4206.Message.Counter = ifelse(all(is.na(`X4206.Message.Counter`)), NA, max(`X4206.Message.Counter`, na.rm = TRUE)),
            min.4206.Message.Counter = ifelse(all(is.na(`X4206.Message.Counter`)), NA, min(`X4206.Message.Counter`, na.rm = TRUE)))


downsampled_5015 <- canbus_data %>%
  group_by(Time = Time5015) %>%
  summarize(mean.5015.Momentary.Engine.Maximum.Power.Enable = mean(`X5015.Momentary.Engine.Maximum.Power.Enable`, na.rm = TRUE),
            sd.5015.Momentary.Engine.Maximum.Power.Enable = sd(`X5015.Momentary.Engine.Maximum.Power.Enable`, na.rm = TRUE),
            max.5015.Momentary.Engine.Maximum.Power.Enable = ifelse(all(is.na(`X5015.Momentary.Engine.Maximum.Power.Enable`)), NA, max(`X5015.Momentary.Engine.Maximum.Power.Enable`, na.rm = TRUE)),
            min.5015.Momentary.Engine.Maximum.Power.Enable = ifelse(all(is.na(`X5015.Momentary.Engine.Maximum.Power.Enable`)), NA, min(`X5015.Momentary.Engine.Maximum.Power.Enable`, na.rm = TRUE)))


downsampled_514 <- canbus_data %>%
  group_by(Time = Time514) %>%
  summarize(mean.514.Nominal.Friction...Percent.Torque = mean(`X514.Nominal.Friction...Percent.Torque`, na.rm = TRUE),
            sd.514.Nominal.Friction...Percent.Torque = sd(`X514.Nominal.Friction...Percent.Torque`, na.rm = TRUE),
            max.514.Nominal.Friction...Percent.Torque = ifelse(all(is.na(`X514.Nominal.Friction...Percent.Torque`)), NA, max(`X514.Nominal.Friction...Percent.Torque`, na.rm = TRUE)),
            min.514.Nominal.Friction...Percent.Torque = ifelse(all(is.na(`X514.Nominal.Friction...Percent.Torque`)), NA, min(`X514.Nominal.Friction...Percent.Torque`, na.rm = TRUE)))


downsampled_187 <- canbus_data %>%
  group_by(Time = Time187) %>%
  summarize(mean.187.Power.Takeoff.Set.Speed = mean(`X187.Power.Takeoff.Set.Speed`, na.rm = TRUE),
            sd.187.Power.Takeoff.Set.Speed = sd(`X187.Power.Takeoff.Set.Speed`, na.rm = TRUE),
            max.187.Power.Takeoff.Set.Speed = ifelse(all(is.na(`X187.Power.Takeoff.Set.Speed`)), NA, max(`X187.Power.Takeoff.Set.Speed`, na.rm = TRUE)),
            min.187.Power.Takeoff.Set.Speed = ifelse(all(is.na(`X187.Power.Takeoff.Set.Speed`)), NA, min(`X187.Power.Takeoff.Set.Speed`, na.rm = TRUE)))


downsampled_905 <- canbus_data %>%
  group_by(Time = Time905) %>%
  summarize(mean.905.Relative.Speed..Front.Axle..Left.Wheel = mean(`X905.Relative.Speed..Front.Axle..Left.Wheel`, na.rm = TRUE),
            sd.905.Relative.Speed..Front.Axle..Left.Wheel = sd(`X905.Relative.Speed..Front.Axle..Left.Wheel`, na.rm = TRUE),
            max.905.Relative.Speed..Front.Axle..Left.Wheel = ifelse(all(is.na(`X905.Relative.Speed..Front.Axle..Left.Wheel`)), NA, max(`X905.Relative.Speed..Front.Axle..Left.Wheel`, na.rm = TRUE)),
            min.905.Relative.Speed..Front.Axle..Left.Wheel = ifelse(all(is.na(`X905.Relative.Speed..Front.Axle..Left.Wheel`)), NA, min(`X905.Relative.Speed..Front.Axle..Left.Wheel`, na.rm = TRUE)))


downsampled_906 <- canbus_data %>%
  group_by(Time = Time906) %>%
  summarize(mean.906.Relative.Speed..Front.Axle..Right.Wheel = mean(`X906.Relative.Speed..Front.Axle..Right.Wheel`, na.rm = TRUE),
            sd.906.Relative.Speed..Front.Axle..Right.Wheel = sd(`X906.Relative.Speed..Front.Axle..Right.Wheel`, na.rm = TRUE),
            max.906.Relative.Speed..Front.Axle..Right.Wheel = ifelse(all(is.na(`X906.Relative.Speed..Front.Axle..Right.Wheel`)), NA, max(`X906.Relative.Speed..Front.Axle..Right.Wheel`, na.rm = TRUE)),
            min.906.Relative.Speed..Front.Axle..Right.Wheel = ifelse(all(is.na(`X906.Relative.Speed..Front.Axle..Right.Wheel`)), NA, min(`X906.Relative.Speed..Front.Axle..Right.Wheel`, na.rm = TRUE)))


downsampled_907 <- canbus_data %>%
  group_by(Time = Time907) %>%
  summarize(mean.907.Relative.Speed..Rear.Axle..1..Left.Wheel = mean(`X907.Relative.Speed..Rear.Axle..1..Left.Wheel`, na.rm = TRUE),
            sd.907.Relative.Speed..Rear.Axle..1..Left.Wheel = sd(`X907.Relative.Speed..Rear.Axle..1..Left.Wheel`, na.rm = TRUE),
            max.907.Relative.Speed..Rear.Axle..1..Left.Wheel = ifelse(all(is.na(`X907.Relative.Speed..Rear.Axle..1..Left.Wheel`)), NA, max(`X907.Relative.Speed..Rear.Axle..1..Left.Wheel`, na.rm = TRUE)),
            min.907.Relative.Speed..Rear.Axle..1..Left.Wheel = ifelse(all(is.na(`X907.Relative.Speed..Rear.Axle..1..Left.Wheel`)), NA, min(`X907.Relative.Speed..Rear.Axle..1..Left.Wheel`, na.rm = TRUE)))


downsampled_908 <- canbus_data %>%
  group_by(Time = Time908) %>%
  summarize(mean.908.Relative.Speed..Rear.Axle..1..Right.Wheel = mean(`X908.Relative.Speed..Rear.Axle..1..Right.Wheel`, na.rm = TRUE),
            sd.908.Relative.Speed..Rear.Axle..1..Right.Wheel = sd(`X908.Relative.Speed..Rear.Axle..1..Right.Wheel`, na.rm = TRUE),
            max.908.Relative.Speed..Rear.Axle..1..Right.Wheel = ifelse(all(is.na(`X908.Relative.Speed..Rear.Axle..1..Right.Wheel`)), NA, max(`X908.Relative.Speed..Rear.Axle..1..Right.Wheel`, na.rm = TRUE)),
            min.908.Relative.Speed..Rear.Axle..1..Right.Wheel = ifelse(all(is.na(`X908.Relative.Speed..Rear.Axle..1..Right.Wheel`)), NA, min(`X908.Relative.Speed..Rear.Axle..1..Right.Wheel`, na.rm = TRUE)))


downsampled_1087 <- canbus_data %>%
  group_by(Time = Time1087) %>%
  summarize(mean.1087.Service.Brake.Circuit.1.Air.Pressure = mean(`X1087.Service.Brake.Circuit.1.Air.Pressure`, na.rm = TRUE),
            sd.1087.Service.Brake.Circuit.1.Air.Pressure = sd(`X1087.Service.Brake.Circuit.1.Air.Pressure`, na.rm = TRUE),
            max.1087.Service.Brake.Circuit.1.Air.Pressure = ifelse(all(is.na(`X1087.Service.Brake.Circuit.1.Air.Pressure`)), NA, max(`X1087.Service.Brake.Circuit.1.Air.Pressure`, na.rm = TRUE)),
            min.1087.Service.Brake.Circuit.1.Air.Pressure = ifelse(all(is.na(`X1087.Service.Brake.Circuit.1.Air.Pressure`)), NA, min(`X1087.Service.Brake.Circuit.1.Air.Pressure`, na.rm = TRUE)))


downsampled_1088 <- canbus_data %>%
  group_by(Time = Time1088) %>%
  summarize(mean.1088.Service.Brake.Circuit.2.Air.Pressure = mean(`X1088.Service.Brake.Circuit.2.Air.Pressure`, na.rm = TRUE),
            sd.1088.Service.Brake.Circuit.2.Air.Pressure = sd(`X1088.Service.Brake.Circuit.2.Air.Pressure`, na.rm = TRUE),
            max.1088.Service.Brake.Circuit.2.Air.Pressure = ifelse(all(is.na(`X1088.Service.Brake.Circuit.2.Air.Pressure`)), NA, max(`X1088.Service.Brake.Circuit.2.Air.Pressure`, na.rm = TRUE)),
            min.1088.Service.Brake.Circuit.2.Air.Pressure = ifelse(all(is.na(`X1088.Service.Brake.Circuit.2.Air.Pressure`)), NA, min(`X1088.Service.Brake.Circuit.2.Air.Pressure`, na.rm = TRUE)))


downsampled_3544 <- canbus_data %>%
  group_by(Time = Time3544) %>%
  summarize(mean.3544.Time.Remaining.in.Engine.Operating.State = mean(`X3544.Time.Remaining.in.Engine.Operating.State`, na.rm = TRUE),
            sd.3544.Time.Remaining.in.Engine.Operating.State = sd(`X3544.Time.Remaining.in.Engine.Operating.State`, na.rm = TRUE),
            max.3544.Time.Remaining.in.Engine.Operating.State = ifelse(all(is.na(`X3544.Time.Remaining.in.Engine.Operating.State`)), NA, max(`X3544.Time.Remaining.in.Engine.Operating.State`, na.rm = TRUE)),
            min.3544.Time.Remaining.in.Engine.Operating.State = ifelse(all(is.na(`X3544.Time.Remaining.in.Engine.Operating.State`)), NA, min(`X3544.Time.Remaining.in.Engine.Operating.State`, na.rm = TRUE)))


downsampled_245 <- canbus_data %>%
  group_by(Time = Time245) %>%
  summarize(mean.245.Total.Vehicle.Distance = mean(`X245.Total.Vehicle.Distance`, na.rm = TRUE),
            sd.245.Total.Vehicle.Distance = sd(`X245.Total.Vehicle.Distance`, na.rm = TRUE),
            max.245.Total.Vehicle.Distance = ifelse(all(is.na(`X245.Total.Vehicle.Distance`)), NA, max(`X245.Total.Vehicle.Distance`, na.rm = TRUE)),
            min.245.Total.Vehicle.Distance = ifelse(all(is.na(`X245.Total.Vehicle.Distance`)), NA, min(`X245.Total.Vehicle.Distance`, na.rm = TRUE)))


downsampled_161 <- canbus_data %>%
  group_by(Time = Time161) %>%
  summarize(mean.161.Transmission.1.Input.Shaft.Speed = mean(`X161.Transmission.1.Input.Shaft.Speed`, na.rm = TRUE),
            sd.161.Transmission.1.Input.Shaft.Speed = sd(`X161.Transmission.1.Input.Shaft.Speed`, na.rm = TRUE),
            max.161.Transmission.1.Input.Shaft.Speed = ifelse(all(is.na(`X161.Transmission.1.Input.Shaft.Speed`)), NA, max(`X161.Transmission.1.Input.Shaft.Speed`, na.rm = TRUE)),
            min.161.Transmission.1.Input.Shaft.Speed = ifelse(all(is.na(`X161.Transmission.1.Input.Shaft.Speed`)), NA, min(`X161.Transmission.1.Input.Shaft.Speed`, na.rm = TRUE)))


downsampled_191 <- canbus_data %>%
  group_by(Time = Time191) %>%
  summarize(mean.191.Transmission.1.Output.Shaft.Speed = mean(`X191.Transmission.1.Output.Shaft.Speed`, na.rm = TRUE),
            sd.191.Transmission.1.Output.Shaft.Speed = sd(`X191.Transmission.1.Output.Shaft.Speed`, na.rm = TRUE),
            max.191.Transmission.1.Output.Shaft.Speed = ifelse(all(is.na(`X191.Transmission.1.Output.Shaft.Speed`)), NA, max(`X191.Transmission.1.Output.Shaft.Speed`, na.rm = TRUE)),
            min.191.Transmission.1.Output.Shaft.Speed = ifelse(all(is.na(`X191.Transmission.1.Output.Shaft.Speed`)), NA, min(`X191.Transmission.1.Output.Shaft.Speed`, na.rm = TRUE)))


downsampled_526 <- canbus_data %>%
  group_by(Time = Time526) %>%
  summarize(mean.526.Transmission.Actual.Gear.Ratio = mean(`X526.Transmission.Actual.Gear.Ratio`, na.rm = TRUE),
            sd.526.Transmission.Actual.Gear.Ratio = sd(`X526.Transmission.Actual.Gear.Ratio`, na.rm = TRUE),
            max.526.Transmission.Actual.Gear.Ratio = ifelse(all(is.na(`X526.Transmission.Actual.Gear.Ratio`)), NA, max(`X526.Transmission.Actual.Gear.Ratio`, na.rm = TRUE)),
            min.526.Transmission.Actual.Gear.Ratio = ifelse(all(is.na(`X526.Transmission.Actual.Gear.Ratio`)), NA, min(`X526.Transmission.Actual.Gear.Ratio`, na.rm = TRUE)))


downsampled_5052 <- canbus_data %>%
  group_by(Time = Time5052) %>%
  summarize(mean.5052.Transmission.Clutch.Converter.Input.Speed = mean(`X5052.Transmission.Clutch.Converter.Input.Speed`, na.rm = TRUE),
            sd.5052.Transmission.Clutch.Converter.Input.Speed = sd(`X5052.Transmission.Clutch.Converter.Input.Speed`, na.rm = TRUE),
            max.5052.Transmission.Clutch.Converter.Input.Speed = ifelse(all(is.na(`X5052.Transmission.Clutch.Converter.Input.Speed`)), NA, max(`X5052.Transmission.Clutch.Converter.Input.Speed`, na.rm = TRUE)),
            min.5052.Transmission.Clutch.Converter.Input.Speed = ifelse(all(is.na(`X5052.Transmission.Clutch.Converter.Input.Speed`)), NA, min(`X5052.Transmission.Clutch.Converter.Input.Speed`, na.rm = TRUE)))


downsampled_523 <- canbus_data %>%
  group_by(Time = Time523) %>%
  summarize(mean.523.Transmission.Current.Gear = mean(`X523.Transmission.Current.Gear`, na.rm = TRUE),
            sd.523.Transmission.Current.Gear = sd(`X523.Transmission.Current.Gear`, na.rm = TRUE),
            max.523.Transmission.Current.Gear = ifelse(all(is.na(`X523.Transmission.Current.Gear`)), NA, max(`X523.Transmission.Current.Gear`, na.rm = TRUE)),
            min.523.Transmission.Current.Gear = ifelse(all(is.na(`X523.Transmission.Current.Gear`)), NA, min(`X523.Transmission.Current.Gear`, na.rm = TRUE)))


downsampled_177 <- canbus_data %>%
  group_by(Time = Time177) %>%
  summarize(mean.177.Transmission.Oil.Temperature.1 = mean(`X177.Transmission.Oil.Temperature.1`, na.rm = TRUE),
            sd.177.Transmission.Oil.Temperature.1 = sd(`X177.Transmission.Oil.Temperature.1`, na.rm = TRUE),
            max.177.Transmission.Oil.Temperature.1 = ifelse(all(is.na(`X177.Transmission.Oil.Temperature.1`)), NA, max(`X177.Transmission.Oil.Temperature.1`, na.rm = TRUE)),
            min.177.Transmission.Oil.Temperature.1 = ifelse(all(is.na(`X177.Transmission.Oil.Temperature.1`)), NA, min(`X177.Transmission.Oil.Temperature.1`, na.rm = TRUE)))


downsampled_524 <- canbus_data %>%
  group_by(Time = Time524) %>%
  summarize(mean.524.Transmission.Selected.Gear = mean(`X524.Transmission.Selected.Gear`, na.rm = TRUE),
            sd.524.Transmission.Selected.Gear = sd(`X524.Transmission.Selected.Gear`, na.rm = TRUE),
            max.524.Transmission.Selected.Gear = ifelse(all(is.na(`X524.Transmission.Selected.Gear`)), NA, max(`X524.Transmission.Selected.Gear`, na.rm = TRUE)),
            min.524.Transmission.Selected.Gear = ifelse(all(is.na(`X524.Transmission.Selected.Gear`)), NA, min(`X524.Transmission.Selected.Gear`, na.rm = TRUE)))


downsampled_574 <- canbus_data %>%
  group_by(Time = Time574) %>%
  summarize(mean.574.Transmission.Shift.In.Process = mean(`X574.Transmission.Shift.In.Process`, na.rm = TRUE),
            sd.574.Transmission.Shift.In.Process = sd(`X574.Transmission.Shift.In.Process`, na.rm = TRUE),
            max.574.Transmission.Shift.In.Process = ifelse(all(is.na(`X574.Transmission.Shift.In.Process`)), NA, max(`X574.Transmission.Shift.In.Process`, na.rm = TRUE)),
            min.574.Transmission.Shift.In.Process = ifelse(all(is.na(`X574.Transmission.Shift.In.Process`)), NA, min(`X574.Transmission.Shift.In.Process`, na.rm = TRUE)))


downsampled_573 <- canbus_data %>%
  group_by(Time = Time573) %>%
  summarize(mean.573.Transmission.Torque.Converter.Lockup.Engaged = mean(`X573.Transmission.Torque.Converter.Lockup.Engaged`, na.rm = TRUE),
            sd.573.Transmission.Torque.Converter.Lockup.Engaged = sd(`X573.Transmission.Torque.Converter.Lockup.Engaged`, na.rm = TRUE),
            max.573.Transmission.Torque.Converter.Lockup.Engaged = ifelse(all(is.na(`X573.Transmission.Torque.Converter.Lockup.Engaged`)), NA, max(`X573.Transmission.Torque.Converter.Lockup.Engaged`, na.rm = TRUE)),
            min.573.Transmission.Torque.Converter.Lockup.Engaged = ifelse(all(is.na(`X573.Transmission.Torque.Converter.Lockup.Engaged`)), NA, min(`X573.Transmission.Torque.Converter.Lockup.Engaged`, na.rm = TRUE)))


downsampled_4816 <- canbus_data %>%
  group_by(Time = Time4816) %>%
  summarize(mean.4816.Transmission.Torque.Converter.Lockup.Transition.in.Process = mean(`X4816.Transmission.Torque.Converter.Lockup.Transition.in.Process`, na.rm = TRUE),
            sd.4816.Transmission.Torque.Converter.Lockup.Transition.in.Process = sd(`X4816.Transmission.Torque.Converter.Lockup.Transition.in.Process`, na.rm = TRUE),
            max.4816.Transmission.Torque.Converter.Lockup.Transition.in.Process = ifelse(all(is.na(`X4816.Transmission.Torque.Converter.Lockup.Transition.in.Process`)), NA, max(`X4816.Transmission.Torque.Converter.Lockup.Transition.in.Process`, na.rm = TRUE)),
            min.4816.Transmission.Torque.Converter.Lockup.Transition.in.Process = ifelse(all(is.na(`X4816.Transmission.Torque.Converter.Lockup.Transition.in.Process`)), NA, min(`X4816.Transmission.Torque.Converter.Lockup.Transition.in.Process`, na.rm = TRUE)))


downsampled_3030 <- canbus_data %>%
  group_by(Time = Time3030) %>%
  summarize(mean.3030.Transmission.Torque.Converter.Ratio = mean(`X3030.Transmission.Torque.Converter.Ratio`, na.rm = TRUE),
            sd.3030.Transmission.Torque.Converter.Ratio = sd(`X3030.Transmission.Torque.Converter.Ratio`, na.rm = TRUE),
            max.3030.Transmission.Torque.Converter.Ratio = ifelse(all(is.na(`X3030.Transmission.Torque.Converter.Ratio`)), NA, max(`X3030.Transmission.Torque.Converter.Ratio`, na.rm = TRUE)),
            min.3030.Transmission.Torque.Converter.Ratio = ifelse(all(is.na(`X3030.Transmission.Torque.Converter.Ratio`)), NA, min(`X3030.Transmission.Torque.Converter.Ratio`, na.rm = TRUE)))


downsampled_1029 <- canbus_data %>%
  group_by(Time = Time1029) %>%
  summarize(mean.1029.Trip.Average.Fuel.Rate = mean(`X1029.Trip.Average.Fuel.Rate`, na.rm = TRUE),
            sd.1029.Trip.Average.Fuel.Rate = sd(`X1029.Trip.Average.Fuel.Rate`, na.rm = TRUE),
            max.1029.Trip.Average.Fuel.Rate = ifelse(all(is.na(`X1029.Trip.Average.Fuel.Rate`)), NA, max(`X1029.Trip.Average.Fuel.Rate`, na.rm = TRUE)),
            min.1029.Trip.Average.Fuel.Rate = ifelse(all(is.na(`X1029.Trip.Average.Fuel.Rate`)), NA, min(`X1029.Trip.Average.Fuel.Rate`, na.rm = TRUE)))


downsampled_244 <- canbus_data %>%
  group_by(Time = Time244) %>%
  summarize(mean.244.Trip.Distance = mean(`X244.Trip.Distance`, na.rm = TRUE),
            sd.244.Trip.Distance = sd(`X244.Trip.Distance`, na.rm = TRUE),
            max.244.Trip.Distance = ifelse(all(is.na(`X244.Trip.Distance`)), NA, max(`X244.Trip.Distance`, na.rm = TRUE)),
            min.244.Trip.Distance = ifelse(all(is.na(`X244.Trip.Distance`)), NA, min(`X244.Trip.Distance`, na.rm = TRUE)))


downsampled_918 <- canbus_data %>%
  group_by(Time = Time918) %>%
  summarize(mean.918.Trip.Distance..High.Resolution. = mean(`X918.Trip.Distance..High.Resolution.`, na.rm = TRUE),
            sd.918.Trip.Distance..High.Resolution. = sd(`X918.Trip.Distance..High.Resolution.`, na.rm = TRUE),
            max.918.Trip.Distance..High.Resolution. = ifelse(all(is.na(`X918.Trip.Distance..High.Resolution.`)), NA, max(`X918.Trip.Distance..High.Resolution.`, na.rm = TRUE)),
            min.918.Trip.Distance..High.Resolution. = ifelse(all(is.na(`X918.Trip.Distance..High.Resolution.`)), NA, min(`X918.Trip.Distance..High.Resolution.`, na.rm = TRUE)))


downsampled_2979 <- canbus_data %>%
  group_by(Time = Time2979) %>%
  summarize(mean.2979.Vehicle.Acceleration.Rate.Limit.Status = mean(`X2979.Vehicle.Acceleration.Rate.Limit.Status`, na.rm = TRUE),
            sd.2979.Vehicle.Acceleration.Rate.Limit.Status = sd(`X2979.Vehicle.Acceleration.Rate.Limit.Status`, na.rm = TRUE),
            max.2979.Vehicle.Acceleration.Rate.Limit.Status = ifelse(all(is.na(`X2979.Vehicle.Acceleration.Rate.Limit.Status`)), NA, max(`X2979.Vehicle.Acceleration.Rate.Limit.Status`, na.rm = TRUE)),
            min.2979.Vehicle.Acceleration.Rate.Limit.Status = ifelse(all(is.na(`X2979.Vehicle.Acceleration.Rate.Limit.Status`)), NA, min(`X2979.Vehicle.Acceleration.Rate.Limit.Status`, na.rm = TRUE)))


downsampled_84 <- canbus_data %>%
  group_by(Time = Time84) %>%
  summarize(mean.84.Wheel.Based.Vehicle.Speed = mean(`X84.Wheel.Based.Vehicle.Speed`, na.rm = TRUE),
            sd.84.Wheel.Based.Vehicle.Speed = sd(`X84.Wheel.Based.Vehicle.Speed`, na.rm = TRUE),
            max.84.Wheel.Based.Vehicle.Speed = ifelse(all(is.na(`X84.Wheel.Based.Vehicle.Speed`)), NA, max(`X84.Wheel.Based.Vehicle.Speed`, na.rm = TRUE)),
            min.84.Wheel.Based.Vehicle.Speed = ifelse(all(is.na(`X84.Wheel.Based.Vehicle.Speed`)), NA, min(`X84.Wheel.Based.Vehicle.Speed`, na.rm = TRUE)))

downsampled_gps <- canbus_data %>%
  group_by(Time = timestampHeading) %>%
  summarize(mean.gpsSpeed = mean(gpsSpeed, na.rm = TRUE),
            sd.gpsSpeed = sd(gpsSpeed, na.rm = TRUE),
            max.gpsSpeed = ifelse(all(is.na(gpsSpeed)), NA, max(gpsSpeed, na.rm = TRUE)),
            min.gpsSpeed = ifelse(all(is.na(gpsSpeed)), NA, min(gpsSpeed, na.rm = TRUE)),
            mean.headingDegree = mean(headingDegree, na.rm = TRUE),
            sd.headingDegree = sd(headingDegree, na.rm = TRUE),
            max.headingDegree = ifelse(all(is.na(headingDegree)), NA, max(headingDegree, na.rm = TRUE)),
            min.headingDegree = ifelse(all(is.na(headingDegree)), NA, min(headingDegree, na.rm = TRUE)))

downsampled_location <- canbus_data %>%
  group_by(Time = timestampsLocation) %>%
  summarize(mean.longitude = mean(longitude, na.rm = TRUE),
            sd.longitude = sd(longitude, na.rm = TRUE),
            max.longitude = ifelse(all(is.na(longitude)), NA, max(longitude, na.rm = TRUE)),
            min.longitude = ifelse(all(is.na(longitude)), NA, min(longitude, na.rm = TRUE)),
            mean.latitude = mean(latitude, na.rm = TRUE),
            sd.latitude = sd(latitude, na.rm = TRUE),
            max.latitude = ifelse(all(is.na(latitude)), NA, max(latitude, na.rm = TRUE)),
            min.latitude = ifelse(all(is.na(latitude)), NA, min(latitude, na.rm = TRUE)))

downsampled_sat <- canbus_data %>%
  group_by(Time = timestampSat) %>%
  summarize(mean.numSats = mean(numSats, na.rm = TRUE),
            sd.numSats = sd(numSats, na.rm = TRUE),
            max.numSats = ifelse(all(is.na(numSats)), NA, max(numSats, na.rm = TRUE)),
            min.numSats = ifelse(all(is.na(numSats)), NA, min(numSats, na.rm = TRUE)))

downsampled_EDA <- canbus_data %>%
  group_by(Time = EDATime) %>%
  summarize(mean.EDA = mean(EDA, na.rm = TRUE),
            sd.EDA = sd(EDA, na.rm = TRUE),
            max.EDA = ifelse(all(is.na(EDA)), NA, max(EDA, na.rm = TRUE)),
            min.EDA = ifelse(all(is.na(EDA)), NA, min(EDA, na.rm = TRUE)))

downsampled_HR <- canbus_data %>%
  group_by(Time = HRTime) %>%
  summarize(mean.HR = mean(HR, na.rm = TRUE),
            sd.HR = sd(HR, na.rm = TRUE),
            max.HR = ifelse(all(is.na(HR)), NA, max(HR, na.rm = TRUE)),
            min.HR = ifelse(all(is.na(HR)), NA, min(HR, na.rm = TRUE)))

downsampled_IBI <- canbus_data %>%
  group_by(Time = IBITime) %>%
  summarize(mean.IBI = mean(IBI, na.rm = TRUE),
            sd.IBI = sd(IBI, na.rm = TRUE),
            max.IBI = ifelse(all(is.na(IBI)), NA, max(IBI, na.rm = TRUE)),
            min.IBI = ifelse(all(is.na(IBI)), NA, min(IBI, na.rm = TRUE)))

# Merge all downsampled data frames
canbus_data <- downsampled_91 %>%
  full_join(downsampled_2945, by = "Time") %>%
  full_join(downsampled_513, by = "Time") %>%
  full_join(downsampled_4154, by = "Time") %>%
  full_join(downsampled_3357, by = "Time") %>%
  full_join(downsampled_1717, by = "Time") %>%
  full_join(downsampled_3031, by = "Time") %>%
  full_join(downsampled_1761, by = "Time") %>%
  full_join(downsampled_4765, by = "Time") %>%
  full_join(downsampled_3251, by = "Time") %>%
  full_join(downsampled_3242, by = "Time") %>%
  full_join(downsampled_3610, by = "Time") %>%
  full_join(downsampled_3246, by = "Time") %>%
  full_join(downsampled_5466, by = "Time") %>%
  full_join(downsampled_3721, by = "Time") %>%
  full_join(downsampled_3241, by = "Time") %>%
  full_join(downsampled_3229, by = "Time") %>%
  full_join(downsampled_3232, by = "Time") %>%
  full_join(downsampled_3226, by = "Time") %>%
  full_join(downsampled_3230, by = "Time") %>%
  full_join(downsampled_3231, by = "Time") %>%
  full_join(downsampled_4360, by = "Time") %>%
  full_join(downsampled_5862, by = "Time") %>%
  full_join(downsampled_4363, by = "Time") %>%
  full_join(downsampled_3239, by = "Time") %>%
  full_join(downsampled_171, by = "Time") %>%
  full_join(downsampled_108, by = "Time") %>%
  full_join(downsampled_168, by = "Time") %>%
  full_join(downsampled_117, by = "Time") %>%
  full_join(downsampled_118, by = "Time") %>%
  full_join(downsampled_5313, by = "Time") %>%
  full_join(downsampled_7319, by = "Time") %>%
  full_join(downsampled_512, by = "Time") %>%
  full_join(downsampled_515, by = "Time") %>%
  full_join(downsampled_185, by = "Time") %>%
  full_join(downsampled_110, by = "Time") %>%
  full_join(downsampled_101, by = "Time") %>%
  full_join(downsampled_2432, by = "Time") %>%
  full_join(downsampled_1136, by = "Time") %>%
  full_join(downsampled_3216, by = "Time") %>%
  full_join(downsampled_1209, by = "Time") %>%
  full_join(downsampled_2659, by = "Time") %>%
  full_join(downsampled_412, by = "Time") %>%
  full_join(downsampled_27, by = "Time") %>%
  full_join(downsampled_975, by = "Time") %>%
  full_join(downsampled_986, by = "Time") %>%
  full_join(downsampled_157, by = "Time") %>%
  full_join(downsampled_183, by = "Time") %>%
  full_join(downsampled_184, by = "Time") %>%
  full_join(downsampled_132, by = "Time") %>%
  full_join(downsampled_102, by = "Time") %>%
  full_join(downsampled_105, by = "Time") %>%
  full_join(downsampled_100, by = "Time") %>%
  full_join(downsampled_92, by = "Time") %>%
  full_join(downsampled_898, by = "Time") %>%
  full_join(downsampled_4191, by = "Time") %>%
  full_join(downsampled_518, by = "Time") %>%
  full_join(downsampled_190, by = "Time") %>%
  full_join(downsampled_190CAN0, by = "Time") %>%
  full_join(downsampled_51, by = "Time") %>%
  full_join(downsampled_250, by = "Time") %>%
  full_join(downsampled_247, by = "Time") %>%
  full_join(downsampled_236, by = "Time") %>%
  full_join(downsampled_235, by = "Time") %>%
  full_join(downsampled_249, by = "Time") %>%
  full_join(downsampled_182, by = "Time") %>%
  full_join(downsampled_1172, by = "Time") %>%
  full_join(downsampled_103, by = "Time") %>%
  full_join(downsampled_641, by = "Time") %>%
  full_join(downsampled_2978, by = "Time") %>%
  full_join(downsampled_5398, by = "Time") %>%
  full_join(downsampled_904, by = "Time") %>%
  full_join(downsampled_96, by = "Time") %>%
  full_join(downsampled_1242, by = "Time") %>%
  full_join(downsampled_4207, by = "Time") %>%
  full_join(downsampled_4206, by = "Time") %>%
  full_join(downsampled_5015, by = "Time") %>%
  full_join(downsampled_514, by = "Time") %>%
  full_join(downsampled_187, by = "Time") %>%
  full_join(downsampled_905, by = "Time") %>%
  full_join(downsampled_906, by = "Time") %>%
  full_join(downsampled_907, by = "Time") %>%
  full_join(downsampled_908, by = "Time") %>%
  full_join(downsampled_1087, by = "Time") %>%
  full_join(downsampled_1088, by = "Time") %>%
  full_join(downsampled_3544, by = "Time") %>%
  full_join(downsampled_245, by = "Time") %>%
  full_join(downsampled_161, by = "Time") %>%
  full_join(downsampled_191, by = "Time") %>%
  full_join(downsampled_526, by = "Time") %>%
  full_join(downsampled_5052, by = "Time") %>%
  full_join(downsampled_523, by = "Time") %>%
  full_join(downsampled_177, by = "Time") %>%
  full_join(downsampled_524, by = "Time") %>%
  full_join(downsampled_574, by = "Time") %>%
  full_join(downsampled_573, by = "Time") %>%
  full_join(downsampled_4816, by = "Time") %>%
  full_join(downsampled_3030, by = "Time") %>%
  full_join(downsampled_1029, by = "Time") %>%
  full_join(downsampled_244, by = "Time") %>%
  full_join(downsampled_918, by = "Time") %>%
  full_join(downsampled_2979, by = "Time") %>%
  full_join(downsampled_84, by = "Time") %>%
  full_join(downsampled_gps, by = "Time") %>%
  full_join(downsampled_location, by = "Time") %>%
  full_join(downsampled_sat, by = "Time") %>%
  full_join(downsampled_EDA, by = "Time") %>%
  full_join(downsampled_HR, by = "Time") %>%
  full_join(downsampled_IBI, by = "Time")

# Create the interval_1s column
canbus_data_downsampled <- canbus_data %>%
  mutate(interval_1s = as.numeric(difftime(Time, Time[1], units = "secs"))) %>%
  select(Time, interval_1s, everything())

# Filter combined_data based on the time
cyberattack_data <- canbus_data_downsampled %>%
  filter(interval_1s > 1300 & interval_1s < 1800)

# Plot CANbus and VBOX speed variables
CAN0_comparison <- 
  ggplot(cyberattack_data, aes(x = interval_1s)) +
  geom_line(aes(y = mean.190.Engine.Speed.CAN0, color = "CAN0")) +
  geom_line(aes(y = mean.190.Engine.Speed, color = "Engine Speed")) +
  labs(title = "CAN0 Engine Speed Comparison", x = "Interval (s)", y = "Engine Speed") +
  scale_color_manual(values = c("CANbus Speed" = "blue", "CAN0" = "red", "Engine Speed" = "green")) +
  theme_minimal()

print(CAN0_comparison)

# Select relevant columns for correlation
engine_speed_data <- canbus_data_downsampled %>%
  select(mean.190.Engine.Speed.CAN0, mean.190.Engine.Speed)

# Calculate correlation matrix
engine_speed_correlation_matrix <- cor(engine_speed_data, use = "complete.obs")

# Print the correlation matrix
print("Engine speed correlation matrix:")
print(engine_speed_correlation_matrix)

# Plot CANbus and VBOX speed variables
speed_comparison <- 
  ggplot(cyberattack_data, aes(x = interval_1s)) +
  geom_line(aes(y = mean.gpsSpeed, color = "GPS Speed")) +
  geom_line(aes(y = mean.84.Wheel.Based.Vehicle.Speed, color = "Wheel-Based Vehicle Speed")) +
  labs(title = "Speed Comparison", x = "Interval (s)", y = "Speed (km/h)") +
  scale_color_manual(values = c("GPS Speed" = "red", "Wheel-Based Vehicle Speed" = "green")) +
  theme_minimal()

print(speed_comparison)

# Select relevant columns for correlation
speed_data <- canbus_data_downsampled %>%
  select(mean.gpsSpeed, mean.84.Wheel.Based.Vehicle.Speed)

# Calculate correlation matrix
speed_correlation_matrix <- cor(speed_data, use = "complete.obs")

# Print the correlation matrix
print("Speed correlation matrix:")
print(speed_correlation_matrix)


# Extract Group and Subject from the filename
file_parts <- strsplit(gsub(".csv", "", file_name), "_")[[1]]
Group <- as.numeric(sub("G", "", file_parts[1]))
Subject <- as.numeric(sub("Subject", "", file_parts[2]))

# Define the cumulative subject counts by group
subject_offsets <- c(0, 17, 33)  # Group 1 has 17, Group 2 starts at 18, Group 3 starts at 34

# Calculate the ID based on Group and Subject
ID <- subject_offsets[Group] + Subject

# Add columns for Group and Subject based on sheet name 
# Modify combined_data dynamically
combined_data <- canbus_data_downsampled %>% 
  mutate(ID = ID,
         Group = Group,
         Subject = Subject) %>%
  select(ID, Group, Subject, everything())

#combined_data <- combined_data %>%
#  rename(Time = Time.x) %>%    # Rename "Time.x" to "Time"
#  rename(mean.190.Engine.Speed.CAN0 = mean.190.Engine.Speed.CAN0.y) %>%
#  rename(sd.190.Engine.Speed.CAN0 = sd.190.Engine.Speed.CAN0.y) %>%
#  rename(max.190.Engine.Speed.CAN0 = max.190.Engine.Speed.CAN0.y) %>%
#  rename(min.190.Engine.Speed.CAN0 = min.190.Engine.Speed.CAN0.y) %>%
#  select(-mean.190.Engine.Speed.CAN0.x, -sd.190.Engine.Speed.CAN0.x, -max.190.Engine.Speed.CAN0.x, -min.190.Engine.Speed.CAN0.x,
#         -Time.x.x, -Time.y, -Time.y.y, -Time.x.x.x, -Time.y.y.y, -Time.x.x.x.x, -Time.y.y.y.y)
###########################

# Save as .csv 
# Save combined_data as a .csv file with the file name same as the sheet name with _test at the end
# Write all rows except the last row to CSV
# Write all rows except the last row and exclude "time" and "time_converted" columns
output_filename <- paste0(file_parts[1], "_", file_parts[2], "_test2.csv")
combined_data %>%
  #slice(1:(n() - 1)) %>%
  write.csv(output_filename, row.names = FALSE)
print("Wrote File")
}