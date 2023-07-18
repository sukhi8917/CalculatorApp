package com.example.mycalculatorapp;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {
    TextView textup,textmain;
    private  double first,second, result;
    private String operation,answer;

    private Button button0;
    private Button button1;
    private Button button2;
    private Button button3;
    private Button button4;
    private Button button5;
    private Button button6;
    private Button button7;
    private Button button8;
    private Button button9;
    private Button buttonDel;
    private Button buttonBackspace;
    private Button buttonadd;
    private Button buttonsub;
    private Button buttonmul;
    private Button buttondiv;
    private Button buttonper;  //per=remainder
    private Button buttoneql;
    private Button buttonDot;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        textup=findViewById(R.id.textup);
        textmain=findViewById(R.id.textmain);
        button0=findViewById(R.id.button0);
        button1=findViewById(R.id.button1);
        button2=findViewById(R.id.button2);
        button3=findViewById(R.id.button3);
        button4=findViewById(R.id.button4);
        button5=findViewById(R.id.button5);
        button6=findViewById(R.id.button6);
        button7=findViewById(R.id.button7);
        button8=findViewById(R.id.button8);
        button9=findViewById(R.id.button9);
        buttonDel=findViewById(R.id.buttonDel);
        buttonBackspace=findViewById(R.id.buttonBackspace);
        buttonper=findViewById(R.id.buttonper);
        buttonsub=findViewById(R.id.buttonsub);
        buttondiv=findViewById(R.id.buttondiv);
        buttonDot=findViewById(R.id.buttonDot);
        buttonadd=findViewById(R.id.buttonadd);
        buttonmul=findViewById(R.id.buttonmul);
        buttoneql=findViewById(R.id.buttoneql);


        buttonDel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                textup.setText(null);
                textmain.setText(null);
            }
        });

        //button for click 0-9 and dot button
        ButtonClick(button0);
        ButtonClick(button1);
        ButtonClick(button2);
        ButtonClick(button3);
        ButtonClick(button4);
        ButtonClick(button5);
        ButtonClick(button6);
        ButtonClick(button7);
        ButtonClick(button8);
        ButtonClick(button9);
        ButtonClick(buttonDot);





        //button for backspace
        buttonBackspace.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String Backspace=null;

                if(textmain.toString().length()>0){
                    StringBuilder stringBuilder=new StringBuilder(textmain.getText());
                    stringBuilder.deleteCharAt(textmain.getText().length()-1);
                    Backspace=stringBuilder.toString();
                    textmain.setText(Backspace);
                }

            }
        });


        //code for operators
        buttonper.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String primary;
                first=Double.parseDouble((String) textmain.getText() );
                primary=String.format("%.2f",first);
                textup.setText(primary);  //setting up text  or text ko upr first textview me set kar rahe h

                textmain.setText("");
                operation="%";
            }
        });


        buttonsub.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("DefaultLocale")
            @Override
            public void onClick(View v) {
                String primary;
                first=Double.parseDouble((String) textmain.getText() );
                primary=String.format("%.2f",first);
                textup.setText(primary);

                textmain.setText("");
                operation="-";
            }
        });


        buttonadd.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("DefaultLocale")
            @Override
            public void onClick(View v) {
                String primary;
                first=Double.parseDouble((String) textmain.getText() );
                primary=String.format("%.2f",first);
                textup.setText(primary);

                textmain.setText("");
                operation="+";
            }
        });


        buttondiv.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("DefaultLocale")
            @Override
            public void onClick(View v) {
                String primary;
                first=Double.parseDouble((String) textmain.getText() );
                primary=String.format("%.2f",first);
                textup.setText(primary);

                textmain.setText("");
                operation="/";
            }
        });


        buttonmul.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("DefaultLocale")
            @Override
            public void onClick(View v) {
                String primary;
                first=Double.parseDouble((String) textmain.getText() );
                primary=String.format("%.2f",first);
                textup.setText(primary);

                textmain.setText("");
                operation="*";
            }
        });



        //button for Equal operation
        buttoneql.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("DefaultLocale")
            @Override
            public void onClick(View v) {
                second=Double.parseDouble((String) textmain.getText());

                if(operation=="+"){
                    result=first+second;
                    answer=String.format("%.2f",result);
                    textmain.setText(answer);
                    textup.setText(null);
                }


                if(operation=="/"){
                    result=first/second;
                    answer=String.format("%.2f",result);
                    textmain.setText(answer);
                    textup.setText(null);
                }


                if(operation=="*"){
                    result=first*second;
                    answer=String.format("%.2f",result);
                    textmain.setText(answer);
                    textup.setText(null);
                }


                if(operation=="-"){
                    result=first-second;
                    answer=String.format("%.2f",result);
                    textmain.setText(answer);
                    textup.setText(null);
                }


                if(operation=="%"){
                    result=first%second;
                    answer=String.format("%.2f",result);
                    textmain.setText(answer);
                    textup.setText(null);
                }
            }
        });
    }

    public  void ButtonClick(Button button){
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String text;
                text=textmain.getText().toString()+button.getText().toString();
                textmain.setText(text);
            }
        });
    }
}