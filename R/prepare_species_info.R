#’
#' prepare_species_info
#'
#' This function simply prepares information for the each species to be displayed in the shiny application. This function has no inputs.
#'
#' @return returns a list with character string variables containing descriptions for each species.
#' @export
#'

prepare_species_info <- function(){

  # Prepare fox information
  fox_info <- "The Red fox (Vulpes Vulpes) is a carnivore with a distribution that spans mainland Britain with populations found in high density suburban spaces across England and Wales. Red foxes’ are nocturnal and typically prey on game birds, ground nesting birds and small mammals (but rarely hedgehogs), however their success in human habitats can be attributed to their opportunistic diet with foxes also consuming a variety of human food waste and showing little adversity to human activity. Red foxes court in January, communicating using distinct barks. In March, females can birth as many as 12 pups. Red foxes use dens – small holes dug into the ground or bunkers in abandoned human habitation – for rearing pups as well as resting."

  # Prepare muntjac information
  muntjac_info <- "The Reeves muntjac deer (Muntiacus reevesi) are an invasive species, introduced to Woburn Park and the surrounding woodland in Bedfordshire in 1984. The deer is native to China, but they have since expanded across Southeast England, and are most abundant in deciduous woodland, seeking cover in the forest understorey. Muntjac browse on shrubs, herbs and brambles and pose a threat to many native wildflowers. Male muntjac have long canine teeth or ‘tusks’ which they use to compete for territory which they then mark with scent glands in their forehead. Muntjac breed across the year but usually birth only one offspring at a time. Like foxes, they have a distinct bark, earning them the nickname, 'barking deer'."

  # Prepare hedgehog information
  hedgehog_info <- "The hedgehog (Erinaceus europaeus) is a common species in parks and gardens across mainland Britain showing preference for edges of woodland, hedgerows, and suburban habitats where food is abudant. Hedgehogs are insectivores, consuming largely worms, caterpillars, slugs, and beetles, but they are also opportunistic and can also consume the eggs and chicks of ground nesting birds, can scavenge on a variety of human food waste. Hedgehogs hibernate between November and April in nests made of leaves, constructed under sheltered areas such as a bush or log pile. Hedgehogs are nocturnal, foraging at night and resting in nests during the day. Females will often birth and rear litters of 4-5 young between the months April and September. When threatened, a hedgehog may run for shelter or roll into a defensive ball of spines. Hedgehog populations are threatened by a variety of man made factors. The renovation of old fencing can remove the holes hedgehogs use to navigate gardens for food, and hedgehogs are often harmed by road traffic, dogs, and garden strimmers. There remains uncertainty over the size of hedgehog populations in the UK, however their population is thought to be declining.  For more information on how to make your garden more habitable for hedgehogs, please see: https://www.britishhedgehogs.org.uk/leaflets/Hedgehog-Street-top-tips.pdf"

  # Prepare badger information
  badger_info <- "The European badger (Meles meles) is the UK's largest land carnivore. Badgers are nocturnal and hunt small mammals, including hedgehogs, as well as birds. They have an opportunistic diet and will also consume fruits, plants, and human food waste. Badgers are found across woodland areas in England, Wales, and Scotland. They are more averse to humans compared to foxes, however populations are emerging in London parks including Hampstead Heath. Badgers have powerful front paws that allow them to construct networks of tunnels called “Setts” where they live in large family groups with multiple adults. The cubs are birthed in January and February by only emerge in March where they continue to wean for another month until they are able to feed independently. There remains uncertainty over the abundance and stability of badgers populations in the UK. Mortalities from collisions with traffic are high and Defra is conducting a cull of badgers in Southwest England to curb the spread of bovine tuberculosis, although the evidence justifying the culling is criticised by environmentalists."

  # Prepare dog information
  dog_info <- "Domestic dogs can pursue and harm wildlife, or deter them through their presence. This can disrupt wildlife foraging and other behaviour essential for population survival. Because of this, it is important to distinguish dogs from humans when studying animal distributions."

  # Prepare human information
  human_info <- "Members of public can deter wildife from foraging and it is therefore important to study human spatial usage of the park."

  deer_info <- "Fallow deer (Dama dama) were introduced to the UK and deliberately released by the Normans over 1000 years ago. However, this occurred so long ago that they are no-longer considered invasive. Since then, the deer have expanded their range to broadleaved woodland, grassland, and parks across the UK. Fallow deer are famous for their rutting, which occurs in October. During this period, male bucks establish territory for mating, called rutting stands, by marking soil with urine and hoof prints. They attract female doe with deep belches. This can lead to violent clashes between bucks as competition occurs for opportunities to mate with groups of doe. Unlike the reeves muntjac, fallow deer compete with other males using their large antlers. Between June and July, the female doe will each birth a single fawn. Fallow deer graze on grasses and herbs, and browse on broadleaf tree saplings. They have no natural predators, and because of this populations are occasionally culled to prevent them disrupting them the regeneration of woodland."

  # Prepare information for remaining species
  other_info <- "No information currently included"

  # Combine this information into a list
  list(fox = fox_info, muntjac = muntjac_info, hedgehog = hedgehog_info, badger = badger_info, dog = dog_info, human = human_info, deer = deer_info, other = other_info)

}
