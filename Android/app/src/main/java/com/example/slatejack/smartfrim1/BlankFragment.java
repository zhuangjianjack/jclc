package com.example.slatejack.smartfrim1;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;


public class BlankFragment extends Fragment {
    private List<String> mList = new ArrayList<>();
    private List<String> mList1 = new ArrayList<>();

    public BlankFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View txview=inflater.inflate( R.layout.fragment_blank, container, false );
        initData();
        initData1();
        initView(txview);
        return txview;
    }
    private void initData() {
        mList.add( "农场一" );
        mList.add( "农场二" );
        mList.add( "农场三" );
        mList.add( "农场四" );
        mList.add( "农场五" );
        mList.add( "农场六" );
        mList.add( "农场七" );
        mList.add( "农场八" );
        mList.add( "农场九" );
    }
    private void initData1() {
        mList1.add( "点击进入农场一管理界面" );
        mList1.add( "点击进入农场二管理界面" );
        mList1.add( "点击进入农场三管理界面" );
        mList1.add( "点击进入农场四管理界面" );
        mList1.add( "点击进入农场五管理界面" );
        mList1.add( "点击进入农场六管理界面" );
        mList1.add( "点击进入农场七管理界面" );
        mList1.add( "点击进入农场八管理界面" );
        mList1.add( "点击进入农场九管理界面" );
    }
    @SuppressLint("WrongConstant")
    private void initView (View txview) {
        VerticalAdapter adapter1 = new VerticalAdapter( getActivity().getApplicationContext());
        RecyclerView rcvVertical = txview.findViewById( R.id.rcv_vertical );
        LinearLayoutManager managerVertical = new LinearLayoutManager( getActivity().getApplicationContext() );
        managerVertical.setOrientation( LinearLayoutManager.VERTICAL );
        rcvVertical.setLayoutManager( managerVertical );
        rcvVertical.setHasFixedSize( true );
        rcvVertical.setAdapter( adapter1 );
        adapter1.setVerticalDataList( mList,mList1);//将数据从main3传递到verticalAdapter内
        adapter1.setOnItemClickListener( new VerticalAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {//根据verticalAdapter里获取到的cardview地址号定义每一个cardview点击逻辑
                //定义相应的事件逻辑
                switch (position) {
                    case 0: {
                        Intent intent1 = new Intent(getActivity().getApplicationContext(), nongchang.class );
                        BlankFragment.this.startActivity( intent1 );
                        break;
                    }

                }
            }
        } );

    }
}
