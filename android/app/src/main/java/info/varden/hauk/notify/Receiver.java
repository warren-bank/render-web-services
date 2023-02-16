package info.varden.hauk.notify;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import java.lang.reflect.InvocationTargetException;

import info.varden.hauk.Constants;
import info.varden.hauk.utils.ReceiverDataRegistry;

/**
 * This class is used to create intents for use in notification buttons that can store an object for
 * retrieval by the associated receiver class. The class maintains a registry of objects for each
 * receiver registered; these objects are returned to the receiver when it is called.
 *
 * @author Marius Lindvall
 * @param <T> The type of data to be passed to the receiving listener.
 */
final class Receiver<T> {
    private final Class<? extends HaukBroadcastReceiver<T>> receiver;
    private final Context ctx;
    private final T data;

    /**
     * Creates a receiver instance.
     *
     * @param ctx      The Android application context.
     * @param receiver The class that Android will instantiate when the proper broadcast is issued.
     * @param data     A data object that will be passed to the broadcast receiver instance.
     */
    Receiver(Context ctx, Class<? extends HaukBroadcastReceiver<T>> receiver, T data) {
        this.receiver = receiver;
        this.ctx = ctx;
        this.data = data;
    }

    /**
     * Creates a PendingIntent from this receiver. Used to add handlers to notification buttons.
     *
     * @return A PendingIntent for use in a notification action.
     * @throws InstantiationException if the broadcast receiver cannot be instantiated.
     * @throws IllegalAccessException if the broadcast receiver hides the action ID function.
     * @throws NoSuchMethodException if the broadcast receiver does not have a constructor.
     * @throws InvocationTargetException if the constructor itself throws an exception.
     */
    @SuppressWarnings("MethodWithTooExceptionsDeclared")
    PendingIntent toPending() throws InstantiationException, IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        // Create a new intent for the receiver.
        Intent intent = new Intent(this.ctx, this.receiver);

        // Retrieve the action ID from the broadcast receiver class.
        intent.setAction(this.receiver.getConstructor().newInstance().getActionID());

        // Store the provided data in the registry for later retrieval, and pass the data index to
        // the intent.
        intent.putExtra(Constants.EXTRA_BROADCAST_RECEIVER_REGISTRY_INDEX, ReceiverDataRegistry.register(this.data));

        return PendingIntent.getBroadcast(this.ctx, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
    }
}
