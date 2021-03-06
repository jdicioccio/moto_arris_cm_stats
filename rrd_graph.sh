#!/bin/bash
for channel in $(seq 1 32); do
  for ds in power snr corr_e uncorr_e lock_st; do
    title_extra=""
    echo $ds | grep -E '_e$' >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      title_extra="per second"
    fi

    rrdtool graph -s -432000 -e -300 -t "Channel ${channel} - ${ds} ${title_extra}" -w 1162 ds_${channel}_${ds}.png \
       DEF:var=inet.rrd:${channel}_ds_${ds}:AVERAGE \
       LINE1:var#FF0000 \
       VDEF:varavg=var,AVERAGE \
       VDEF:varmax=var,MAXIMUM \
       VDEF:varlast=var,LAST \
       GPRINT:varlast:" Current\:%8.2lf %s " \
       GPRINT:varavg:"Average\:%8.2lf %s" \
       GPRINT:varmax:"Maximum\:%8.2lf %s"
  done
done

for channel in $(seq 1 4); do
  for us in power; do
    title_extra=""
    echo $us | grep -E '_e$' >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      title_extra="per second"
    fi

    rrdtool graph -s -432000 -e -300 -t "Channel ${channel} - ${us} ${title_extra}" -w 1162 us_${channel}_${us}.png \
      DEF:var=inet.rrd:${channel}_us_${us}:AVERAGE \
      LINE1:var#FF0000 \
      VDEF:varavg=var,AVERAGE \
      VDEF:varmax=var,MAXIMUM \
      VDEF:varlast=var,LAST \
      GPRINT:varlast:" Current\:%8.2lf %s " \
      GPRINT:varavg:"Average\:%8.2lf %s" \
      GPRINT:varmax:"Maximum\:%8.2lf %s"
  done
done

rrdtool graph -s -432000 -e -300 -t "Modem System Uptime" -w 1162 system_uptime.png \
  DEF:var=inet.rrd:system_uptime:AVERAGE \
  LINE1:var#FF0000 \
  VDEF:varlast=var,LAST \
  VDEF:varmax=var,MAXIMUM \
  GPRINT:varlast:" Current\:%10.0lf %s " \
  GPRINT:varmax:"Maximum\:%10.0lf %s"

