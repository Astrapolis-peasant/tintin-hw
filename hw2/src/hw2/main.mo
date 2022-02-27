import Array "mo:base/Array";
import Int "mo:base/Int";

actor {
    func quicksort(arr:[Int]) : [Int] {
        let n = arr.size();
        if (n < 2) {
            return arr;
        } else {
            var newArr:[var Int] = Array.thaw(arr);
            sortHelper(newArr,0,newArr.size()-1);
            Array.freeze(newArr)
        };    
    };

    func sortHelper(array:[var Int],left:Nat,right:Nat){
        if(left>=right) return;
        let temp = array[left];
        var leftPointer = left;
        var rightPointer = right;
        while(leftPointer < rightPointer){
            while(array[rightPointer] >= temp and rightPointer > leftPointer){
                rightPointer -= 1;
            };
            array[leftPointer] := array[rightPointer];
            while(array[leftPointer] <= temp and leftPointer < rightPointer){
                leftPointer += 1;
            };
            array[rightPointer] := array[leftPointer];
        };
        array[rightPointer] := temp;
        if(leftPointer >= 1) sortHelper(array,left,leftPointer-1);
        sortHelper(array,leftPointer+1,right);
};

assert(quicksort([2,1,3]) == ([1,2,3]));

    public query func qsort(arr : [Int]) : async [Int] {
        quicksort(arr);
    };
};
