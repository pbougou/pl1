#include <cstdio>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <queue>
#include <vector>
#include <stack>
using namespace std;

/*
	#define space_ch '.'
	#define end		 'E'
	#define start	 'S'
	#define wormhole 'W'
	#define no_pass  'X'
*/

class Point{

public:

    int i;
    int j;
    int pizza;
   	Point(int _i,int _j,int _pizza) {i=_i; j=_j; pizza=_pizza;}

};

struct parent {
    Point point;
};

int map[1000][1000];
int main(int argc , char *argv[]){
    char *path = argv[1];
    FILE *fp;
    fp=fopen(path,"r");
    int c;
    int i,j;
    c=fgetc(fp);
    i=0;
    int N=0,M=0;
    j=0;
    int i_start=0,j_start=0;
    int i_end=0,j_end=0;
     while ( c!=EOF ) {
        if(c == '\n') {
            i++; M = j; j = 0;
        }
        else {
            switch(c) {
                case '.':
                    map[i][j] = 0;
                    break;
                case 'E':{
                	i_end=i;
                	j_end=j;
                    map[i][j] = 1;
                    break;
                }
                case 'S':{
                	i_start=i;
                	j_start=j;
                    map[i][j] = 2;
                    break;
                }
                case 'W':
                    map[i][j] = 3;
                    break;
                case 'X':
                    map[i][j] = 4;
                    break;
            }
            j++;
          }
          c = fgetc(fp);
    }
N=i;
//printf("N=%d M=%d \n",i,M);


//========================= VECTOR FOR NODE LABELS =======================================//
vector< vector < int  >  > node_label_w_pizza(N,vector<int>(M,INT_MAX));
vector< vector < int  >  > node_label_n_pizza(N,vector<int>(M,INT_MAX));
//=======================================================================================//


node_label_w_pizza.at(i_start).at(j_start)=0; // Starting Point label initialized to 0


queue <Point> bfs_queue; // Queue for BFS

vector< vector < int  >  > *temp;
vector< vector < int  >  > *temp1;

struct parent **parents_w = (struct parent **)malloc(N * sizeof(struct parent *));
    for(i = 0; i < N; i++)
        parents_w[i] = (struct parent *)malloc(M * sizeof(struct parent));
    
    for(i = 0; i < N; i++)
        for(j = 0; j < M; j++) {
            parents_w[i][j].point =Point(INT_MAX,INT_MAX,0);
        }

struct parent **parents_n = (struct parent **)malloc(N * sizeof(struct parent *));
    for(i = 0; i < N; i++)
        parents_n[i] = (struct parent *)malloc(M * sizeof(struct parent));
    
    for(i = 0; i < N; i++)
        for(j = 0; j < M; j++) {
            parents_n[i][j].point=Point(INT_MAX,INT_MAX,0);
            
        }

    parents_w[i_start][j_start].point =Point(-1,-1,1);
    


struct parent **parents;
parents=NULL;
struct parent **parents2;



bfs_queue.push(Point(i_start,j_start,1));

Point p(0,0,0);
int pizza;
int cost;
int cost2;
    while(bfs_queue.empty()!=1)
    {


        p=bfs_queue.front();
        bfs_queue.pop();
        pizza=p.pizza;

        if(pizza==1){
            parents=parents_w;
            parents2=parents_n;
            temp=&node_label_w_pizza;
            temp1=&node_label_n_pizza;
            cost=2;
            cost2=1;
        }
        else {
            parents=parents_n;
            parents2=parents_w;
            temp=&node_label_n_pizza; 
            temp1=&node_label_w_pizza;
            cost=1;
            cost2=2;
        }



            if(p.i-1 >= 0){
                if(temp->at(p.i).at(p.j)+cost < temp->at(p.i-1).at(p.j) && map[p.i-1][p.j]!=4){
                    bfs_queue.push(Point(p.i-1,p.j,pizza));
                    temp->at(p.i-1).at(p.j)=temp->at(p.i).at(p.j)+cost;
                    parents[p.i-1][p.j].point = p;
                    
                    

                }
            }
            if(p.i+1 < N){
                if(temp->at(p.i).at(p.j)+cost < temp->at(p.i+1).at(p.j) && map[p.i+1][p.j]!=4){
                    bfs_queue.push(Point(p.i+1,p.j,pizza));
                    temp->at(p.i+1).at(p.j)=temp->at(p.i).at(p.j)+cost;
                    parents[p.i+1][p.j].point = p;
                    
                    
            
                }
            }
            if(p.j+1 < M){

                if(temp->at(p.i).at(p.j)+cost < temp->at(p.i).at(p.j+1) && map[p.i][p.j+1]!=4){
                    bfs_queue.push(Point(p.i,p.j+1,pizza));
                    temp->at(p.i).at(p.j+1)=temp->at(p.i).at(p.j)+cost;
                    parents[p.i][p.j+1].point = p;
                    
                    

                }
            }
            if(p.j-1 >= 0){
                if(temp->at(p.i).at(p.j)+cost < temp->at(p.i).at(p.j-1) && map[p.i][p.j-1]!=4){
                    bfs_queue.push(Point(p.i,p.j-1,pizza));
                    //printf("Inserted %d %d %d \n",p.i,p.j-1,pizza);
                    temp->at(p.i).at(p.j-1)=temp->at(p.i).at(p.j)+cost;
                    parents[p.i][p.j-1].point = p;
                    
                    

                }
            }

            if(map[p.i][p.j]==3){
                    if(p.i-1 >= 0){
                        if(temp->at(p.i).at(p.j)+1+cost2 < temp1->at(p.i-1).at(p.j) && map[p.i-1][p.j]!=4){
                            bfs_queue.push(Point(p.i-1,p.j,!pizza));
                            temp1->at(p.i-1).at(p.j)=temp->at(p.i).at(p.j)+1+cost2;
                            parents2[p.i-1][p.j].point = p;
                            
                        }
                    }
                    if(p.i+1 < N){
                        //if(p.i+1==3 && p.j==3) printf("New cost=%d\n",temp->at(p.i).at(p.j)+1+cost2); 
                        if(temp->at(p.i).at(p.j)+1+cost2< temp1->at(p.i+1).at(p.j) && map[p.i+1][p.j]!=4){
                            bfs_queue.push(Point(p.i+1,p.j,!pizza));
                            temp1->at(p.i+1).at(p.j)=temp->at(p.i).at(p.j)+1+cost2;
                            parents2[p.i+1][p.j].point = p;
                            
                        }
                    }
                    if(p.j+1 < M){
                        if(temp->at(p.i).at(p.j)+1+cost2 < temp1->at(p.i).at(p.j+1) && map[p.i][p.j+1]!=4){
                            bfs_queue.push(Point(p.i,p.j+1,!pizza));
                            temp1->at(p.i).at(p.j+1)=temp->at(p.i).at(p.j)+1+cost2;
                            parents2[p.i][p.j+1].point = p;
                            
                        }
                    }
                    if(p.j-1 >= 0){
                        if(temp->at(p.i).at(p.j)+1+cost2 < temp1->at(p.i).at(p.j-1) && map[p.i][p.j-1]!=4){
                            bfs_queue.push(Point(p.i,p.j-1,!pizza));
                            temp1->at(p.i).at(p.j-1)=temp->at(p.i).at(p.j)+1+cost2;
                            parents2[p.i][p.j-1].point = p;
                            
                        }
                    }
            }
    }


    stack<char> s;
    Point current(i_end, j_end,1);
    //printf("i = %d, j = %d\n", current.i, current.j);
    //printf("i = %d, j = %d\n", i_start, j_start);
    int cnt = 0;
    parents=parents_w;
    while(current.i != i_start || current.j != j_start || current.pizza!=1) {
            cnt++;
            struct parent par = parents[current.i][current.j];
            // UP
            if(par.point.i == current.i-1 && par.point.j == current.j) 
                s.push('D');
            // DOWN
            else if(par.point.i == current.i+1 && par.point.j == current.j) 
                s.push('U');
            
            // LEFT
            else if(par.point.i == current.i && par.point.j == current.j-1) 
                s.push('R');
            // RIGHT
            else if(par.point.i == current.i && par.point.j == current.j+1)
                s.push('L');
            else 
                printf("The impossible happenned\n");
            
            if(current.pizza!=par.point.pizza) s.push('W');

            current = Point(par.point.i, par.point.j,par.point.pizza);

            if(par.point.pizza==1) parents=parents_w;
            else parents=parents_n;

    }



printf("%d ", node_label_w_pizza.at(i_end).at(j_end));
int size = s.size();
    for(i = 0; i < size; i++) {
        printf("%c", s.top());
        s.pop();
    }
printf("\n");
}

