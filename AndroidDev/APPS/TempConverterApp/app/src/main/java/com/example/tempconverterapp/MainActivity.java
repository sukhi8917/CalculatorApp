package com.example.tempconverterapp;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        EditText edittake=findViewById(R.id.edittake);
        Button button=findViewById(R.id.button);
        TextView texttmp=findViewById(R.id.texttmp);

        button.setOnClickListener(new View.OnClickListener() {
            @SuppressLint({"DefaultLocale", "SetTextI18n"})
            @Override
            public void onClick(View v) {
                Double far=Double.parseDouble(edittake.getText().toString());
                Double result=((1.8*far) + 32);
                texttmp.setText(String.format("%.2f",result)+"F");
            }
        });
    }
}