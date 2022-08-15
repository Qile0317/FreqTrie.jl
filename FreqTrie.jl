using progressMeter
#creating the custom counting node structure.
mutable struct CTNode
    letter::Char
    count::Int64
    isEnd::Bool
    children::Union{Dict{Char,CTNode},Nothing}
end

#initializing a counttrie with a root
function InitCountTrie()
    return CTNode('R',0,false,Dict{Char,CTNode}())
end

testTrie = InitCountTrie()

#function to add a single sequence to a counttrie
function Tadd(trie::CTNode, seq::String, ret::Bool = false)
    seq = uppercase(seq)
    currNode = trie
    seqlen = length(seq)
    currlen = 0
    for nt in seq
        currlen += 1
        if !haskey(currNode.children, nt)
            if currNode.isEnd == false
                currNode.children[nt] = CTNode(nt,1,false,Dict{Char,CTNode}())
            else
                currNode.children[nt] = CTNode(nt,1,true,nothing)
            end
        else
            currNode.count += 1
        end
        currNode = currNode.children[nt]
    end

    if ret
        return trie
    end
end

#testing. Works
@time Tadd(testTrie,"ATG")
testTrie

#making it so you can add multiple sequences at once.
function Tadd(trie::CTNode, seqs::Vector{String}, ret::Bool = false)
    @showprogress for seq in seqs
        Tadd(trie,seq)
    end
    if ret
        return trie
    end
end

function createCT(seqs::Vector{String}, ret::Bool = false)
    trie = InitCountTrie()
    @showprogress for seq in seqs
        Tadd(trie,seq)
    end
    if ret
        return trie
    end

end

Tadd(testTrie,["GATCGATC","TGCATCA"])
testTrie

function VisTrie(trie::CTNode)
    println("placeholder")
end

#testing function on IgM data from another script.
@time IgM_B_countTrie = Tadd(InitCountTrie(),MBnsa,true)
@time IgM_A_countTrie = createCT(MAnsa,true)

#work in progress. Simple functions to take away, track, visualize, etc. are on the way. 
