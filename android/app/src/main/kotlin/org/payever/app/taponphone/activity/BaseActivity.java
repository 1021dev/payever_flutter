package org.payever.app.taponphone.activity;

import android.content.Context;

import androidx.appcompat.app.AppCompatActivity;

import org.payever.app.taponphone.api.SampleDataProviderImpl;
import org.payever.app.taponphone.models.MposLibraryStatus;
import org.payever.app.taponphone.mpos.MposApplication;
import org.payever.app.taponphone.utils.DataManager;

public class BaseActivity extends AppCompatActivity {

    /**
     * Get the current status of MPOS library
     * @param context contxt of application
     * @return MposLibraryStatus
     */
    MposLibraryStatus getMposLibraryStatus(final Context context) {
        return getDataProvider().getMposLibraryStatus(context);
    }

    SampleDataProviderImpl getDataProvider() {
        return MposApplication.INSTANCE.getDataProvider();
    }

    DataManager getDataManager() {
        return MposApplication.INSTANCE.getDataManager();
    }
}
