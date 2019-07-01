package com.example.slatejack.smartfrim1;


import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.slatejack.smartfrim1.data.VerticalAdapter1;

import java.util.ArrayList;
import java.util.List;


/**
 * A simple {@link Fragment} subclass.
 */
public class FragmentMy extends Fragment {

    private List<String> mList = new ArrayList<>();
    public FragmentMy() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View txview=inflater.inflate( R.layout.fragment_fragment_my, container, false);
        initdata();
        initView( txview );
        return txview;
    }
    private void initdata(){
        mList.add( "切换数据来源" );
        mList.add( "我的农场" );
        mList.add( "帮助与反馈" );
        mList.add( "实验室功能" );
        mList.add( "退出登录" );
    }


    private void initView (View txview) {
        VerticalAdapter1 adapter1 = new VerticalAdapter1( getActivity().getApplicationContext());
        RecyclerView rcvVertical = txview.findViewById( R.id.rcv1 );
        LinearLayoutManager managerVertical = new LinearLayoutManager( getActivity().getApplicationContext() );
        managerVertical.setOrientation( LinearLayoutManager.HORIZONTAL);
        rcvVertical.setLayoutManager( managerVertical );
        rcvVertical.setHasFixedSize( true );
        rcvVertical.setAdapter( adapter1 );
        adapter1.setVerticalDataList( mList);
        adapter1.setOnItemClickListener( new VerticalAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                switch (position) {

                }
            }
        } );
    }
}
