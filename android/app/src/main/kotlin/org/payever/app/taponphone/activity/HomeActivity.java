package org.payever.app.taponphone.activity;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.nfc.NfcAdapter;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.widget.Toolbar;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import com.google.android.material.navigation.NavigationView;

import org.payever.app.R;
import org.payever.app.taponphone.fragment.HomeFragment;
import org.payever.app.taponphone.fragment.LibraryInfoFragment;
import org.payever.app.taponphone.fragment.TerminalOptionsFragment;
import org.payever.app.taponphone.fragment.TransactionLogsFragment;
import org.payever.app.taponphone.fragment.TransactionOptionsFragment;
import org.payever.app.taponphone.models.Interface;
import org.payever.app.taponphone.models.MposLibraryStatus;
import org.payever.app.taponphone.mpos.MposApplication;
import org.payever.app.taponphone.permissions.PermissionHelper;


public class HomeActivity extends BaseActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    /**
     * Read storage permission request code
     */
    private static final int PERMISSION_REQUEST_CODE = 12345;
    /**
     * Flag to check whether permission is granted by user or not
     */
    private boolean isPermissionAccepted;

    private boolean isStoragePermissionAccepted;

    private final BroadcastReceiver mReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            final String action = intent.getAction();
            if (action.equals(NfcAdapter.ACTION_ADAPTER_STATE_CHANGED)) {
                final int state = intent.getIntExtra(NfcAdapter.EXTRA_ADAPTER_STATE,
                        NfcAdapter.STATE_OFF);
                switch (state) {
                    case NfcAdapter.STATE_OFF:
                        Toast.makeText(getApplicationContext(), "Enable NFC and Try Again", Toast.LENGTH_LONG).show();
                        finish();
                        break;
                    case NfcAdapter.STATE_TURNING_OFF:
                        Toast.makeText(getApplicationContext(), "Enable NFC and Restart MPOS", Toast.LENGTH_LONG).show();
                        finish();
                        break;
                    default:
                        break;
                }
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        initWidget();

        displaySelectedFragment(R.id.nav_home);
        isPermissionAccepted = checkStoragePermission();
        //initialize
        if (isPermissionAccepted) {
            initializeMposApplication();
            IntentFilter filter = new IntentFilter(NfcAdapter.ACTION_ADAPTER_STATE_CHANGED);
            this.registerReceiver(mReceiver, filter);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
//        isPermissionAccepted = checkStoragePermission();
//        if (isPermissionAccepted) {
//            initializeMposApplication();
//            IntentFilter filter = new IntentFilter(NfcAdapter.ACTION_ADAPTER_STATE_CHANGED);
//            this.registerReceiver(mReceiver, filter);
//        }
    }

    void initializeMposApplication() {
        MposApplication.INSTANCE.initializeMposLibrary(this);
        // check if NFC is enabled
        if (!MposApplication.INSTANCE.getNfcProvider().isNfcEnabled()) {
            Toast.makeText(this.getApplicationContext(), "Enable NFC and Try Again", Toast.LENGTH_LONG).show();
            finish();
        } else {
            MposApplication.INSTANCE.updateInterface(Interface.INTERNAL_NFC);
            Toast.makeText(this.getApplicationContext(), "Using internal NFC as default reader", Toast.LENGTH_LONG).show();
        }
    }

    /**
     * Initialize the ui widgets
     */
    private void initWidget() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open,
                R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);
        navigationView.setItemIconTintList(null);

        View header = navigationView.getHeaderView(0);

        MposLibraryStatus mposLibraryStatus = getMposLibraryStatus(this);

        TextView statusText = (TextView) header.findViewById(R.id.status_text);
        statusText.setText(mposLibraryStatus.getStatus());

        TextView currentInterfaceText = (TextView) header.findViewById(R.id.current_interface_text);
        currentInterfaceText.setText(mposLibraryStatus.getCurrentInterface());

        TextView additionalInfoText = (TextView) header.findViewById(R.id.additional_info_text);
        additionalInfoText.setText(mposLibraryStatus.getAdditionalInfo());
    }

    /**
     * Display the fragment selected from navigation drawer
     *
     * @param id id of selected item
     */
    private void displaySelectedFragment(final int id) {
        Fragment fragment = null;

        if (id == R.id.nav_home) {
            fragment = new HomeFragment();
        } else if (id == R.id.nav_terminal_option) {
            fragment = new TerminalOptionsFragment();
        } else if (id == R.id.nav_transaction_option) {
            fragment = new TransactionOptionsFragment();
        } else if (id == R.id.nav_library_info) {
            fragment = new LibraryInfoFragment();
        } else if (id == R.id.nav_transaction_logs) {
            //Check if the required permissions are granted by user.
            if (checkStoragePermission()) {
                fragment = new TransactionLogsFragment();
            }
        }

        if (fragment != null) {
            FragmentTransaction fragmentTransaction =
                    getSupportFragmentManager().beginTransaction();
            fragmentTransaction.replace(R.id.content_frame, fragment);
            fragmentTransaction.commit();
        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
    }

    /**
     * Check the read storage permission
     *
     * @return true if request permission is granted else return false
     */
    private boolean checkStoragePermission() {
        final String permissionsRequired = Manifest.permission.WRITE_EXTERNAL_STORAGE;
        return PermissionHelper.requestPermissions(permissionsRequired,
                this, PERMISSION_REQUEST_CODE);
    }


    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public void onRequestPermissionsResult(final int requestCode,
                                           @NonNull final String[] permissions,
                                           @NonNull final int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQUEST_CODE) {
            for (int i = 0; i < permissions.length; i++) {
                checkPermissionResult(permissions[i], grantResults[i]);
            }
        }
    }

    private void checkPermissionResult(String permission, int grantResult) {
        if (permission.equalsIgnoreCase(Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
            if (grantResult == PackageManager.PERMISSION_DENIED) {
                toastDeclinedPermission(getString(R.string.main_permissions_no_read_storage));
            } else if (grantResult == PackageManager.PERMISSION_GRANTED) {
                isStoragePermissionAccepted = true;
                permissionGranted();
            }
        }
    }

    private void permissionGranted() {
        isPermissionAccepted = true;
        if (isStoragePermissionAccepted) {
            initializeMposApplication();
        } else {
            finish();
        }
    }

    private void toastDeclinedPermission(String message) {
        Toast.makeText(getApplicationContext(), message,
                Toast.LENGTH_SHORT).show();
        isPermissionAccepted = false;
    }


    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        displaySelectedFragment(item.getItemId());
        return true;
    }

    @Override
    protected void onStop() {
        super.onStop();
//        if (mReceiver != null) {
//            this.unregisterReceiver(mReceiver);
//            MposApplication.INSTANCE.closeFileConnections();
//        }

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Remove the broadcast listener
        if (mReceiver != null) {
            this.unregisterReceiver(mReceiver);
            MposApplication.INSTANCE.closeFileConnections();
        }
    }

//    public NfcProvider getNfcProvider() {
//        return new NfcProvider(this);
//    }
}
