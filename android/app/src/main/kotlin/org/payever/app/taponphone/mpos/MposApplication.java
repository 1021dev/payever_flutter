package org.payever.app.taponphone.mpos;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.CallSuper;

import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.view.FlutterMain;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.mastercard.terminalsdk.ConfigurationInterface;
import com.mastercard.terminalsdk.LibraryServicesInterface;
import com.mastercard.terminalsdk.TransactionInterface;
import com.mastercard.terminalsdk.emv.Tag;
import com.mastercard.terminalsdk.exception.ConfigurationException;
import com.mastercard.terminalsdk.exception.LibraryCheckedException;
import com.mastercard.terminalsdk.exception.ReaderBusyException;
import com.mastercard.terminalsdk.iso8825.BerTlv;
import com.mastercard.terminalsdk.listeners.CardCommunicationProvider;
import com.mastercard.terminalsdk.listeners.TransactionProcessLogger;
import com.mastercard.terminalsdk.objects.LibraryInformation;
import com.mastercard.terminalsdk.TerminalSdk;
import com.mastercard.terminalsdk.utility.ByteArrayWrapper;
import com.mastercard.terminalsdk.utility.ByteUtility;

import org.payever.app.taponphone.api.SampleDataProviderImpl;
import org.payever.app.taponphone.implementations.CardCommProviderStub;
import org.payever.app.taponphone.implementations.DisplayImplementation;
import org.payever.app.taponphone.implementations.OutcomeObserver;
import org.payever.app.taponphone.implementations.ResourceProviderImplementation;
import org.payever.app.taponphone.implementations.TransactionProcessLoggerImplementation;
import org.payever.app.taponphone.implementations.nfc.NfcProvider;
import org.payever.app.taponphone.models.Interface;
import org.payever.app.taponphone.utils.DataManager;

import io.flutter.view.FlutterMain;

public class MposApplication extends FlutterApplication {


    private final String TAG = "MposApplication";

    /**
     * Application instance
     */
    public static MposApplication INSTANCE;

    /**
     * Instance of {@link DataManager}
     */
    private DataManager mDataManager;
    /**
     * Instance of {@link SampleDataProviderImpl}
     */
    private SampleDataProviderImpl mDataProvider;


    /**
     * Instance of {@link TransactionProcessLogger}
     */
    private TransactionProcessLoggerImplementation mTransactionProcessLogger;

    /**
     * Instance of {@link TransactionInterface}
     */
    private TransactionInterface mTransactionApi;

    /**
     * Instance of {@link ConfigurationInterface}
     */
    private ConfigurationInterface mEmvLibraryConfiguration = null;

    /**
     * Instance of {@link CardCommunicationProvider}
     */
    private NfcProvider mNfcProvider;


    private CardCommunicationProvider mStubImpl;


    /**
     * Instance of {@link com.mastercard.terminalsdk.listeners.TransactionOutcomeObserver}
     */

    private OutcomeObserver mTransactionOutcomeObserver;

    final TerminalSdk emvLibrary = TerminalSdk.getInstance();

    private Activity mCurrentActivity = null;

    public Activity getCurrentActivity() {
        return mCurrentActivity;
    }

    public void setCurrentActivity(Activity mCurrentActivity) {
        this.mCurrentActivity = mCurrentActivity;
    }

    @Override
    @CallSuper
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
        assignInstance(this);
        initializeUiDataComponents();
    }

    private static void assignInstance(MposApplication mposApplication) {
        INSTANCE = mposApplication;
    }

    /**
     * Initialize the ui and data components
     */
    private void initializeUiDataComponents() {
        mDataProvider = new SampleDataProviderImpl();
        mDataManager = new DataManager(this);
    }

    /**
     * Initialize the MPOS library
     */
    public void initializeMposLibrary(Activity activity) {

        mEmvLibraryConfiguration = emvLibrary.getConfiguration();

        //Card Comm Poviders
        mStubImpl = new CardCommProviderStub();
        mNfcProvider = new NfcProvider(activity);

        mTransactionOutcomeObserver = new OutcomeObserver();
        try {
            mTransactionProcessLogger = new TransactionProcessLoggerImplementation();
            mEmvLibraryConfiguration.withLogger(mTransactionProcessLogger)
                    .withCardCommunication(mNfcProvider, mStubImpl)
                    .withTransactionObserver(mTransactionOutcomeObserver)
                    .withResourceProvider(
                            new ResourceProviderImplementation(this.getApplicationContext()))
                    .withMessageDisplayProvider(
                            new DisplayImplementation(mTransactionProcessLogger));
            mTransactionApi = mEmvLibraryConfiguration.initializeLibrary();
        } catch (ConfigurationException e) {
            Log.e(TAG, "initializeMposLibrary: ConfigurationException was "
                    + "encountered " + e.getMessage());
        } catch (LibraryCheckedException ex) {
            Log.e(TAG, "initializeMposLibrary: LibraryCheckedException was "
                    + "encountered " + ex.getMessage());
        }

        setReaderProfile("MPOS");
    }

    /**
     * @return DataProvider
     */
    public SampleDataProviderImpl getDataProvider() {
        return mDataProvider;
    }

    public DataManager getDataManager() {
        return mDataManager;
    }

    /**
     * TransactionInterface object
     *
     * @return mTransactionApi
     */
    public TransactionInterface getTransactionApi() {
        return mTransactionApi;
    }

    public void setReaderProfile(String readerProfile) {
        try {
            mEmvLibraryConfiguration.selectProfile(readerProfile);
        } catch (ReaderBusyException exc) {
            Log.e(TAG, "initializeMposLibrary: ReaderBusyException was "
                    + "encountered " + exc.getMessage());
        }
    }

    public OutcomeObserver getTransactionOutcomeObserver() {
        return mTransactionOutcomeObserver;
    }

    /**
     * Provides TransactionProcessLoggerImplementation object
     *
     * @return mTransactionProcessLogger
     */
    public TransactionProcessLogger getTransactionProcessLogger() {
        return mTransactionProcessLogger;
    }

    /**
     * Provides NfcProvider object
     *
     * @return mNfcProvider
     */
    public NfcProvider getNfcProvider() {
        return mNfcProvider;
    }

    /**
     * Closes the  File connections used for logging
     */
    public void closeFileConnections() {
        mTransactionProcessLogger.closeFileWriter();
    }

    /**
     * Updates Terminal configuration
     *
     * @param tag   Tag to be updated
     * @param value value with which the tag to be updated
     */
    public void updateTerminalData(String tag, String value) {

        Tag wrapperTag = new Tag(Tags.TAG_UPDATE_DATA.getTagBytes(), Tag.Format.b, 0, 255, "Update data");
        BerTlv wrapperTlv = new BerTlv(wrapperTag);

        String tlvToUpdate = tag + ByteUtility.intToBerEncodedLength(value.length() / 2) + value;

        wrapperTlv.setRawBytes(new ByteArrayWrapper(tlvToUpdate));
        try {
            mEmvLibraryConfiguration.update(wrapperTlv);
        } catch (ConfigurationException e) {
            Log.e(TAG, "initializeMposLibrary: ConfigurationException was "
                    + "encountered " + e.getMessage());
        }
    }

    /**
     * @return Library Information
     */
    public LibraryInformation getLibraryInfo() {
        LibraryInformation libInfo = emvLibrary.getLibraryServices().getLibraryInformation();
        mDataManager.saveStringData(DataManager.KEY_LIBRARY_INFO, libInfo.toString());
        return libInfo;
    }

    public LibraryServicesInterface getLibraryServices() {
        return emvLibrary.getLibraryServices();
    }

    public void updateInterface(Interface targetInterface) {

        String readerName = mStubImpl.getDescription();
        switch (targetInterface) {
            case INTERNAL_NFC:
                readerName = mNfcProvider.getDescription();
                break;
            default:
                break;
        }
        try {
            mEmvLibraryConfiguration.setInterface(readerName);
        } catch (ConfigurationException e) {
            e.printStackTrace();
        }
    }

//    @Override
//    public void registerWith(FlutterEngine registry) {
//        GeneratedPluginRegistrant.registerWith(registry);
//    }
}
