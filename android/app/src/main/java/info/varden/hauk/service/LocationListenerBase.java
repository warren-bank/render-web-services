package info.varden.hauk.service;

import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;

import info.varden.hauk.utils.Log;

/**
 * Location listener base class for Hauk. The purpose of this class is to remove unnecessary empty
 * function bodies from LocationPushService's source code.
 *
 * @author Marius Lindvall
 */
abstract class LocationListenerBase implements LocationListener {
    @Override
    public final void onStatusChanged(String provider, int status, Bundle bundle) {
        Log.v("Location status changed for provider %s, status=%s", provider, status); //NON-NLS
    }

    @Override
    public final void onProviderEnabled(String provider) {
        Log.i("Location provider %s was enabled", provider); //NON-NLS
    }

    @Override
    public final void onProviderDisabled(String provider) {
        Log.w("Location provider %s was disabled", provider); //NON-NLS
    }

    /**
     * Request location updates from the given location manager.
     *
     * @param manager The location manager to request location updates from.
     * @return true if successful, false otherwise.
     * @throws SecurityException if location permission has not been granted.
     */
    abstract boolean request(LocationManager manager) throws SecurityException;
}
