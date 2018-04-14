// Disclaimer: http://www.geeksforgeeks.org/disjoint-set-data-structures-java-implementation/
// A Java program to implement Disjoint Set Data
// Structure.
import java.io.*;
import java.util.*;
 
class DisjointUnionSets
{
    int[] rank, parent;
    int n;
 
    // Constructor
    public DisjointUnionSets(int n)
    {
        rank = new int[n];
        parent = new int[n];
        this.n = n;
        makeSet();
    }
 
    // Creates n sets with single item in each
    void makeSet()
    {
        for (int i=0; i<n; i++)
        {
            // Initially, all elements are in
            // their own set.
            parent[i] = i;
        }
    }
 
    // Returns representative of x's set
    int find(int x)
    {
        // Finds the representative of the set
        // that x is an element of
        if (parent[x]!=x)
        {
            // if x is not the parent of itself
            // Then x is not the representative of
            // his set,
            parent[x] = find(parent[x]);
 
            // so we recursively call Find on its parent
            // and move i's node directly under the
            // representative of this set
        }
 
        return parent[x];
    }
 
    // Unites the set that includes x and the set
    // that includes x
    void union(int x, int y)
    {
        // Find representatives of two sets
        int xRoot = find(x), yRoot = find(y);
 
        // Elements are in the same set, no need
        // to unite anything.
        if (xRoot == yRoot)
            return;
 
         // If x's rank is less than y's rank
        if (rank[xRoot] < rank[yRoot])
 
            // Then move x under y  so that depth
            // of tree remains less
            parent[xRoot] = yRoot;
 
        // Else if y's rank is less than x's rank
        else if (rank[yRoot] < rank[xRoot])
 
            // Then move y under x so that depth of
            // tree remains less
            parent[yRoot] = xRoot;
 
        else // if ranks are the same
        {
            // Then move y under x (doesn't matter
            // which one goes where)
            parent[yRoot] = xRoot;
 
            // And increment the the result tree's
            // rank by 1
            rank[xRoot] = rank[xRoot] + 1;
        }
    }
}
 
// Driver code
public class Main
{
    public static void main(String[] args)
    {
		try {
			String s           = args[0];
			FileReader file    = new FileReader(s);
			BufferedReader br  = new BufferedReader(file);
			String first       = br.readLine();
			StringTokenizer st = new StringTokenizer(first);
			
			int N = Integer.parseInt(st.nextToken());
			int M = Integer.parseInt(st.nextToken());
			int K = Integer.parseInt(st.nextToken());

			DisjointUnionSets dus = new DisjointUnionSets(N);
			// dus.makeSet();
			for(int i = 0; i < M; i++) {
				first = br.readLine();
				st    = new StringTokenizer(first);
				int nd_one = Integer.parseInt(st.nextToken());
				int nd_two = Integer.parseInt(st.nextToken());
				
				if(dus.find(nd_one - 1) != dus.find(nd_two - 1)) {
					dus.union(nd_one - 1, nd_two - 1);
				}
			}

			for(int i = 1; i < N; i++) {
				if(dus.find(0) != dus.find(i)) {
					dus.union(0, i);
					K--;
				}
				if(K == 0)
					break;
			}

			int groups = 0;
			for(int i = 0; i < N; i++) {
				if(dus.parent[i] == i)
					groups++;
			}
			System.out.println(groups);



		} catch(IOException e) { e.printStackTrace(); }
        
    }
}
