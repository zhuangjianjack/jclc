package com.example.slatejack.smartfrim1;

import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;

public class MainActivity extends AppCompatActivity {
    private TextView mTextMessage;

    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()) {
                case R.id.navigation_home:
                    BlankFragment firstfragment=new BlankFragment();
                    firstfragment.setArguments( getIntent().getExtras());
                    getSupportFragmentManager()
                            .beginTransaction()
                            .replace(R.id.listFragment,firstfragment)
                            .commit();
                    return true;
                case R.id.navigation_dashboard:
                    FragmentSet firstfragment1=new FragmentSet();
                    firstfragment1.setArguments( getIntent().getExtras());
                    getSupportFragmentManager()
                            .beginTransaction()
                            .replace(R.id.listFragment,firstfragment1)
                            .commit();
                    return true;
                case R.id.navigation_notifications:
                    FragmentMy firstfragment2=new FragmentMy();
                    firstfragment2.setArguments( getIntent().getExtras());
                    getSupportFragmentManager()
                            .beginTransaction()
                            .replace(R.id.listFragment,firstfragment2)
                            .commit();
                    return true;
            }
            return false;
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate( savedInstanceState );
        setContentView( R.layout.activity_main );
        BottomNavigationView navView = findViewById( R.id.nav_view );
        mTextMessage = findViewById( R.id.message );
        navView.setOnNavigationItemSelectedListener( mOnNavigationItemSelectedListener );
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate( R.menu.bottom_nav_menu, menu );
        return true;
    }
}
